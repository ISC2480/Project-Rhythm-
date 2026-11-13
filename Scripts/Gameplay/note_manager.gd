
class_name NoteManager
extends Node

@export var current_chart: SongChart
@onready var note_spawner: NoteSpawner = $"../NoteSpawner"

signal note_missed(note: Note)

const UNITS_PER_BEAT = 4.0
const TRAVEL_DISTANCE = 16.0

var next_note_index: int = 0
var active_notes: Array[Note] = []


# ==================================================
# TEMPORARY DEBUGGING VARIABLES
# ==================================================
# DEBUG START: Lines 1-4 of this section.
# Comment out these 4 declarations when finished.
# Alternatively, set endless_test_enabled to false.
# ==================================================

@export var endless_test_enabled: bool = true
@export var test_note_interval: float = 0.5

var next_test_hit_time: float = -1.0
var next_test_lane: int = 0

# ==================================================
# DEBUG END: Lines 1-4 of the section above.
# ==================================================


# ==================================================
# TEMPORARY DEBUGGING FUNCTION
# ==================================================
# DEBUG START: Comment out the entire function below
# when endless note testing is no longer needed.
#
# IMPORTANT:
# Also comment out its call in gameplay.gd.
# ==================================================

func generate_endless_test_notes(song_time: float) -> void:

	# Stop generating when debugging is disabled.
	if not endless_test_enabled:
		return

	# Only generate notes when a chart exists.
	if current_chart == null:
		return

	# Initialize after the original chart's final note.
	if next_test_hit_time < 0.0:

		var last_hit_time: float = 0.0

		# Find the last scheduled note in the chart.
		for note_data in current_chart.notes:
			last_hit_time = maxf(
				last_hit_time,
				note_data.hit_time
			)

		# Start after the final original note.
		next_test_hit_time = (
			last_hit_time + maxf(test_note_interval, 0.1)
		)

	# Schedule notes ahead of the current song time.
	while next_test_hit_time < song_time + 8.0:

		# Create a new test note.
		var note_data = NoteData.new()

		# Assign the scheduled hit time.
		note_data.hit_time = next_test_hit_time

		# Cycle through the four lanes in order.
		note_data.lane = next_test_lane as Settings.Lane

		# Use a consistent note type and color.
		note_data.note_color = Settings.NoteColor.COLOR_3
		note_data.note_type = NoteData.NoteType.TAP

		# Add the note to the current chart.
		current_chart.notes.append(note_data)

		# Advance to the next lane.
		next_test_lane = (next_test_lane + 1) % 4

		# Schedule the next note.
		next_test_hit_time += maxf(
			test_note_interval, 0.1
		)

# ==================================================
# DEBUG END: Entire function above.
# ==================================================


# ==================================================
# TIMING CALCULATIONS
# ==================================================

func calculate_note_speed() -> float:
	var beats_per_second = current_chart.bpm / 60.0
	return (
		UNITS_PER_BEAT
		* beats_per_second
		* Settings.scroll_speed
	)


func calculate_travel_time() -> float:
	var speed = calculate_note_speed()
	return TRAVEL_DISTANCE / maxf(speed, 0.001)


func calculate_spawn_time(hit_time: float) -> float:
	# Positive display offset shifts visual arrival later.
	var display_offset = Settings.display_offset / 1000.0

	return (
		hit_time
		+ display_offset
		- calculate_travel_time()
	)


# ==================================================
# CHART MANAGING
# ==================================================

func load_chart(chart: SongChart) -> void:

	# Remove notes belonging to the previous chart.
	for note in active_notes:
		note.queue_free()

	active_notes.clear()
	current_chart = chart
	next_note_index = 0

	# ==================================================
	# DEBUG START: Reset temporary endless note generator.
	# Comment out the next 2 lines when finished testing.
	# ==================================================

	next_test_hit_time = -1.0
	next_test_lane = 0

	# DEBUG END: Previous 2 lines.


# ==================================================
# SPAWNING AND MOVING NOTES
# ==================================================

func update_notes(song_time: float) -> void:

	if current_chart == null:
		return

	# Spawn all notes that are due this frame.
	while next_note_index < current_chart.notes.size():

		var note_data: NoteData = current_chart.notes[next_note_index]
		var spawn_time = calculate_spawn_time(note_data.hit_time)

		if song_time < spawn_time:
			break

		var note = note_spawner.spawn_note(note_data)

		if note != null:
			active_notes.append(note)

		next_note_index += 1

	update_note_positions(song_time)
	check_missed_notes(song_time)


func update_note_positions(song_time: float) -> void:

	var travel_time = calculate_travel_time()
	var display_offset = Settings.display_offset / 1000.0

	for note in active_notes:

		var visual_hit_time = note.hit_time + display_offset

		# 0 = spawn position; 1 = judgment line.
		var progress = 1.0 - (
			(visual_hit_time - song_time) / travel_time
		)

		var position = note.global_position

		# Notes travel 16 units along positive Z.
		position.z = lerpf(
			note.spawn_position.z,
			note.spawn_position.z + TRAVEL_DISTANCE,
			progress
		)

		note.global_position = position


# ==================================================
# FINDING NOTES FOR INPUT
# ==================================================

func find_closest_note(lane: int, song_time: float) -> Note:

	var closest_note: Note = null
	var smallest_difference: float = INF

	var offset = Settings.judgement_offset / 1000.0
	var max_window = JudgementSystem.GOOD_WINDOW / 1000.0

	for note in active_notes:

		if note.judged or note.lane != lane:
			continue

		var expected_time = note.hit_time + offset
		var difference = abs(song_time - expected_time)

		if difference <= max_window \
		and difference < smallest_difference:

			smallest_difference = difference
			closest_note = note

	return closest_note


# ==================================================
# REMOVING NOTES AND HANDLING MISSES
# ==================================================

func remove_note(note: Note) -> void:

	note.judged = true
	active_notes.erase(note)
	note.queue_free()


func check_missed_notes(song_time: float) -> void:

	var offset = Settings.judgement_offset / 1000.0
	var max_window = JudgementSystem.GOOD_WINDOW / 1000.0

	for note in active_notes.duplicate():

		var expected_time = note.hit_time + offset

		if song_time > expected_time + max_window:

			note_missed.emit(note)
			remove_note(note)
