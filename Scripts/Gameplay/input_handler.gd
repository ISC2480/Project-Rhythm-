class_name InputHandler
extends Node

signal lane_pressed(lane: int)
signal lane_released(lane: int)
signal bar_pressed # Emitted when the player presses Space.

func _input(event: InputEvent) -> void:
	if not event is InputEventKey: return

	# Ignore key releases and auto-repeat.
	if event.echo: return

	# Space activates the four-lane bar note.
	if event.keycode == KEY_SPACE and event.pressed:
		bar_pressed.emit()
		return

	# Check the player's configured lane bindings and see if they match
	for lane in Settings.lane_key_bindings:
		if event.keycode == Settings.lane_key_bindings[lane]:
			if event.pressed:
				lane_pressed.emit(lane)
			else:
				lane_released.emit(lane)
			break
