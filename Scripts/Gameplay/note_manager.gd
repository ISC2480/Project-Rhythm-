extends Node3D
class_name NoteManager

@export var selected_chart: SongChart
var next_note_index: int 
var active_notes: Array[Note] = [] # Notes on the screen
var current_song_bpm: float = 120.0 # Placeholder BPM

@onready var note_spawner: NoteSpawner = $"../NoteSpawner"

const UNITS_PER_BEAT: float = 4.0
const TRAVEL_DISTANCE: float = 16.0

func _ready() -> void:
	for note_data in selected_chart.notes:
		print("Hit Time: ", note_data.hit_time, " | Lane: ", note_data.lane)


func load_chart(chart: SongChart) -> void:
	selected_chart = chart
	next_note_index = 0


func calculate_note_speed() -> float: # TODO
	var beats_per_second = current_song_bpm / 60.0
	return UNITS_PER_BEAT * beats_per_second * Settings.scroll_speed


func calculate_travel_time() -> float: # TODO
	# Time = Distance / Speed
	return TRAVEL_DISTANCE / calculate_note_speed()


func calculate_spawn_time(hit_time: float) -> float: #TODO
	# converting Settings.display_offset from milliseconds to seconds
	var display_offset = Settings.display_offset / 1000.0
	return hit_time + display_offset - calculate_travel_time()


func update_notes(song_time: float) -> void:
	if selected_chart == null: return
	
	while next_note_index < selected_chart.notes.size():
		var note_data: NoteData = selected_chart.notes[next_note_index]
		var spawn_time = calculate_spawn_time(note_data.hit_time)
		
		if song_time < spawn_time: break # Error
		
		# Call NoteSpawner to create the note in the scene
		var note = note_spawner.spawn_note(note_data)
		if note != null: active_notes.append(note)
		
		next_note_index += 1
		
		update_note_positions(song_time)
		

func update_note_positions(song_time: float) -> void:
	var travel_time = calculate_travel_time()
	# Converting Settings.display_offset from milliseconds to seconds
	var display_offset = Settings.display_offset / 1000.0
	
	for note in active_notes:
		var visual_hit_time = note.hit_time + display_offset
		
		# -16.0 = spawn, -1.0 = judgement line
		var progress = -1.0 - ((visual_hit_time - song_time) / travel_time)
		
		# Move z-position toward the line
		note.global_position.z = lerpf(
			note.spawn_position.z,
			note.spawn_position.z + TRAVEL_DISTANCE,
			progress
		)
