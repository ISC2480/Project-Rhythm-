class_name RhythmInput
extends Node

# The two color modes available to the player.
enum NoteColor {
	RED,
	BLUE
}

# Signals let other scripts respond to the controls.
signal lane_pressed(lane: int, selected_color: NoteColor)
signal lane_released(lane: int)

signal bar_pressed(selected_color: NoteColor)
signal bar_released

signal color_changed(selected_color: NoteColor)

const LANE_ACTIONS: Array[StringName] = [
	&"lane1",
	&"lane2",
	&"lane3",
	&"lane4"
]

# The player should start in black mode.
var current_color: NoteColor = NoteColor.RED


func _input(event: InputEvent) -> void:
	# Toggle the active color.
	if event.is_action_pressed("switchColor"):
		switch_color()
		return

	# Check each of the four lanes.
	for index in range(LANE_ACTIONS.size()):
		var action: StringName = LANE_ACTIONS[index]

		if event.is_action_pressed(action):
			lane_pressed.emit(index + 1, current_color)

		elif event.is_action_released(action):
			lane_released.emit(index + 1)

	# Check the special bar note.
	if event.is_action_pressed("barNote"):
		bar_pressed.emit(current_color)

	elif event.is_action_released("barNote"):
		bar_released.emit()

func switch_color() -> void:
	if current_color == NoteColor.RED:
		current_color = NoteColor.BLUE
	else:
		current_color = NoteColor.RED

	color_changed.emit(current_color)


# Use these functions when checking hold notes.
func is_lane_held(lane: int) -> bool:
	if lane < 1 or lane > LANE_ACTIONS.size():
		return false

	return Input.is_action_pressed(LANE_ACTIONS[lane - 1])


func is_bar_held() -> bool:
	return Input.is_action_pressed("bar_note")


# Converts the gameplay color mode into a visual color.
func get_display_color() -> Color:
	if current_color == NoteColor.RED:
		return Color.RED

	return Color.BLUE
