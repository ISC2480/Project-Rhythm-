extends Node

@export var controls: Node


func _ready() -> void:

	controls.connect("lane_pressed", _on_lane_pressed)
	controls.connect("lane_released", _on_lane_released)

	controls.connect("bar_pressed", _on_bar_pressed)
	controls.connect("bar_released", _on_bar_released)

	controls.connect("color_changed", _on_color_changed)


func _on_lane_pressed(lane: int, selected_color: int) -> void:
	print("Pressed lane: ", lane, " | Color ID: ", selected_color)


func _on_lane_released(lane: int) -> void:
	print("Released lane: ", lane)


func _on_bar_pressed(selected_color: int) -> void:
	print("Pressed bar note | Color ID: ", selected_color)


func _on_bar_released() -> void:
	print("Released bar note")

func _on_color_changed(selected_color: int) -> void:
	print("Selected color ID: ", selected_color, " (0 = RED, 1 = BLUE)")
