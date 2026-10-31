extends Button
signal d_pressed
signal d_released

var is_held: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "d"
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_IGNORE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lane_1"):
		is_held = true
		set_pressed_no_signal(true)
		modulate = Color.BLACK
		d_pressed.emit()
	if Input.is_action_just_released("lane_1"):
		is_held = false
		set_pressed_no_signal(false)
		modulate = Color.WHITE
		d_released.emit()
