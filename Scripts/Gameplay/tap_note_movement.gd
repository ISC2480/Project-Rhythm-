
extends Node3D

@export var note_speed: float = 3.0
@export var is_moving: bool = false

var lane: int = 0
var hit_z: float = -1.0

@onready var models: Array[Node3D] = [
	$ProjectRhythm_TapNote,
	$ProjectRhythm_TapNote2,
	$ProjectRhythm_TapNote3,
	$ProjectRhythm_TapNote4
]

func _ready() -> void:
	for i in range(models.size()):
		if is_moving:
			# Only show the note for the selected lane
			models[i].visible = (i == lane)
		else:
			# Keep all four original notes visible
			models[i].visible = true


func _process(delta: float) -> void:
	# TapNotes at the end never move
	if not is_moving:
		return

	# Move spawned notes toward the player
	position.z += note_speed * delta

	# Delete only moving notes after the hit area
	if position.z > hit_z + 0.5:
		queue_free()
