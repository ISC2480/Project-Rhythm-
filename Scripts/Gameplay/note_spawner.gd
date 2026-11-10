class_name NoteSpawner
extends Node3D

const TAP_NOTE_SCENE = preload("res://Scenes/tap_note.tscn")

@onready var spawn_markers: Dictionary = {
	Settings.Lane.LANE_1: $Spawn1,
	Settings.Lane.LANE_2: $Spawn2,
	Settings.Lane.LANE_3: $Spawn3,
	Settings.Lane.LANE_4: $Spawn4
}
@onready var notes_container: Node3D = $"../Notes"

func spawn_note(note_data: NoteData) -> Note:
	# Find the spawn marker from scene corresponding to the note's lane
	var marker: Marker3D = spawn_markers.get(note_data.lane)

	# Create an instance of note
	var note: Note = TAP_NOTE_SCENE.instantiate() as Note

	if note == null:
		push_error("Tap note scene must inherit from Note.")
		return null

	# Copy the chart information into the runtime note
	note.hit_time = note_data.hit_time
	note.lane = note_data.lane
	note.note_color = note_data.note_color

	# Add the note to the active notes container
	notes_container.add_child(note)

	# Placing the note at the spawn location
	note.global_position = marker.global_position
	note.spawn_position = marker.global_position

	return note
