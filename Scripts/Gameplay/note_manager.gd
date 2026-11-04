extends Node3D
class_name NoteManager

@export var selected_chart: SongChart
var next_note_index: int

func _ready() -> void:
	for note_data in selected_chart.notes:
		print("Hit Time: ", note_data.hit_time, " | Lane: ", note_data.lane)

func load_chart(chart: SongChart) -> void:
	selected_chart = chart
	next_note_index = 0

func calculate_note_speed() -> float: # TODO
	return 0

func calculate_travel_time() -> float: #TODO
	return 0

func calculate_spawn_time() -> float: #TODO
	return 0

func update_notes() -> void:
	pass

func update_note_positions() -> void:
	pass
