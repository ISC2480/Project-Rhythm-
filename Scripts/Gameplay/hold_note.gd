
class_name HoldNote
extends Note

# Hold duration is stored in seconds by NoteData.
var hold_duration: float = 1.0
var note_speed: float = 8.0
var is_holding: bool = false
var hold_failed: bool = false
var hold_finished: bool = false

@onready var tap_model: Node3D = $ProjectRhythm_TapNote

# Store the stretched model's original dimensions.
var full_hold_length: float = 0.0
var full_hold_scale_x: float = 1.0
var full_hold_position_z: float = 0.0

func _ready() -> void:
	update_hold_length()

func update_hold_length() -> void:
	# The imported model is rotated: its LOCAL X axis follows the highway Z axis.
	# Measure the visible model along highway Z before changing its scale.
	var original_length: float = _measure_highway_length(tap_model)
	if original_length <= 0.001:
		push_warning("Could not measure hold model; using fallback length.")
		original_length = 0.5

	var desired_length: float = maxf(original_length, note_speed * hold_duration)
	var extra_length: float = desired_length - original_length
	tap_model.scale.x *= desired_length / original_length

	# Move the elongated model backward so its front stays at the original hit point.
	tap_model.position.z -= extra_length * 0.5

	# Save the full dimensions after stretching the model.
	full_hold_length = desired_length
	full_hold_scale_x = tap_model.scale.x
	full_hold_position_z = tap_model.position.z


# Shrink the hold note based on how much time has passed.
func update_hold_visual(progress: float) -> void:
	progress = clampf(progress, 0.0, 1.0)

	# Calculate the percentage of the hold that remains.
	var remaining: float = 1.0 - progress

	# Hide the model once the hold is completed.
	if remaining <= 0.001:
		tap_model.visible = false
		return

	tap_model.visible = true

	# Shrink along local X because the imported model is rotated.
	tap_model.scale.x = full_hold_scale_x * remaining

	# Move the model backward as it shrinks.
	# This keeps the far end approximately stationary.
	tap_model.position.z = (
		full_hold_position_z
		- full_hold_length * progress * 0.5
	)


func _measure_highway_length(node: Node3D) -> float:
	var minimum: float = INF
	var maximum: float = -INF
	var meshes: Array[MeshInstance3D] = []
	_collect_meshes(node, meshes)
	for mesh_instance in meshes:
		if mesh_instance.mesh == null:
			continue
		var bounds: AABB = mesh_instance.get_aabb()
		for x in [0.0, 1.0]:
			for y in [0.0, 1.0]:
				for z in [0.0, 1.0]:
					var corner: Vector3 = bounds.position + bounds.size * Vector3(x, y, z)
					var point: Vector3 = to_local(mesh_instance.to_global(corner))
					minimum = minf(minimum, point.z)
					maximum = maxf(maximum, point.z)
	if minimum == INF:
		return 0.0
	return maximum - minimum

func _collect_meshes(node: Node, output: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D:
		output.append(node as MeshInstance3D)
	for child in node.get_children():
		_collect_meshes(child, output)
