class_name BarNote
extends Note

@onready var bar_mesh: MeshInstance3D = $BarMesh

# Resize the bar so it covers all four lanes, including the outside edges.
func set_bar_width(width: float) -> void:
	var mesh := bar_mesh.mesh as BoxMesh
	mesh.size.x = width
