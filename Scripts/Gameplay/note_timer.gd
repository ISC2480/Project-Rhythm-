extends Node3D
var lane: int = 0
@export var note_speed: float = 3.0
var hit_z: float = -1.0

func _process(delta: float) -> void:
	position.z += note_speed * delta
	if position.z > hit_z + 0.5:
		queue_free()
