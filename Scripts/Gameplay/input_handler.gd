class_name InputHandler
extends Node

signal lane_pressed(lane: int)

func _input(event: InputEvent) -> void:
	if not event is InputEventKey: return

	# Ignore key releases and auto-repeat.
	if not event.pressed or event.echo: return

	# Check the player's configured lane bindings and see if they match
	for lane in Settings.lane_key_bindings:
		if event.keycode == Settings.lane_key_bindings[lane]:
			lane_pressed.emit(lane)
			break
