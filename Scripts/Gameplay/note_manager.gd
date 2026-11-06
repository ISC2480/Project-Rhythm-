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

func update_notes() -> void:
	pass

func update_note_positions() -> void:
	pass
