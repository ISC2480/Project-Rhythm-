extends Node3D

@export var note_scene: PackedScene = preload("res://note.tscn")
@export_range(0.25, 10.0, 0.25) var note_speed: float = 3.0

const LANE_POSITIONS: Array[float] = [-1.25, -0.20, 0.75, 2.0]

func spawn_note(lane: int) -> void:
	if lane < 0 or lane >= LANE_POSITIONS.size():
		return
	var note = note_scene.instantiate()
	note.lane = lane
	note.note_speed = note_speed
	note.position = Vector3(LANE_POSITIONS[lane], 0.10, -11.0)
	$Notes.add_child(note)
	var mesh_instance: MeshInstance3D = note.get_node("MeshInstance3D")
	var material := StandardMaterial3D.new()
	material.emission_enabled = true
	mesh_instance.material_override = material

func _on_spawn_timer_timeout() -> void:
	spawn_note(randi_range(0, 3))
