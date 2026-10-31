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
	pass
