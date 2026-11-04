
extends Node3D

@export var note_scene: PackedScene = preload(
    "res://Scenes/tapNote.tscn"
)

@export var note_speed: float = 3.0

@export var stationary_tapnotes: Node3D


func spawn_note(lane: int) -> void:
	if lane < 0 or lane >= 4:
		return

	if stationary_tapnotes == null:
		push_warning("Stationary TapNotes not assigned!")
		return

	# Create a new TapNote scene
	var note = note_scene.instantiate()

	# Configure it as a moving note
	note.lane = lane
	note.note_speed = note_speed
	note.is_moving = true

	# Add the note to the scene
	add_child(note)

	# Start at the same origin as the stationary notes
	note.global_transform = stationary_tapnotes.global_transform


func _on_spawn_timer_timeout() -> void:
	var random_lane = randi_range(0, 3)
	spawn_note(random_lane)
