
class_name NoteSpawner
extends Node3D

const TAP_NOTE_SCENE = preload("res://Scenes/tap_note.tscn")
const HOLD_NOTE_SCENE = preload("res://Scenes/hold_note.tscn")
# Wide four lane bar note
const BAR_NOTE_SCENE = preload("res://Scenes/bar_note.tscn")


@onready var spawn_markers: Dictionary = {
	Settings.Lane.LANE_1: $Spawn1,
	Settings.Lane.LANE_2: $Spawn2,
	Settings.Lane.LANE_3: $Spawn3,
	Settings.Lane.LANE_4: $Spawn4
}

@onready var notes_container: Node3D = $"../Notes"


func spawn_note(note_data: NoteData) -> Note:
	var marker: Marker3D = spawn_markers.get(note_data.lane)

	# Both bar types use the four-lane center.
	if note_data.note_type in [
		NoteData.NoteType.BAR,
		NoteData.NoteType.BAR_TWO
	]:
		marker = spawn_markers[Settings.Lane.LANE_1]

	if marker == null:
		push_error("No spawn marker found for note.")
		return null

	var scene_to_spawn: PackedScene = TAP_NOTE_SCENE

	# Choose between the existing note scenes.
	match note_data.note_type:
		NoteData.NoteType.HOLD:
			scene_to_spawn = HOLD_NOTE_SCENE

		NoteData.NoteType.BAR:
			scene_to_spawn = BAR_NOTE_SCENE

	var note: Note = scene_to_spawn.instantiate() as Note

	if note == null:
		push_error("Note scene must inherit from Note.")
		return null

	note.hit_time = note_data.hit_time
	note.lane = note_data.lane
	note.note_color = note_data.note_color
	note.note_type = note_data.note_type

	
	if note is HoldNote:
		var hold: HoldNote = note as HoldNote
		hold.hold_duration = maxf(note_data.hold_duration, 0.01)
		hold.note_speed = get_node(
            "../NoteManager"
		).calculate_note_speed()

	notes_container.add_child(note)

	note.global_position = marker.global_position
	note.spawn_position = marker.global_position

	# Center either bar type across all four lanes.
	if note_data.note_type in [
		NoteData.NoteType.BAR,
		NoteData.NoteType.BAR_TWO
	]:
		var left: Vector3 = spawn_markers[
			Settings.Lane.LANE_1
		].global_position

		var right: Vector3 = spawn_markers[
			Settings.Lane.LANE_4
		].global_position

		note.global_position = (left + right) * 0.5
		note.spawn_position = note.global_position

		var bar_width: float = absf(right.x - left.x) + 0.8

		if note is BarNote:
			(note as BarNote).set_bar_width(bar_width)


	return note
