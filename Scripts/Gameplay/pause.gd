extends Control
@export var settings_scene: PackedScene
@onready var animation_player = $AnimationPlayer
var paused = false
var settings: Control

func _ready() -> void:
	hide()
	paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("pause")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pausemenu()


func _on_resume_pressed() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused=false
		paused=false


func _on_options_pressed() -> void:
	if settings_scene == null:
		push_warning("Assign your settings scene in the Inspector.")
		return
	if not is_instance_valid(settings):
		settings = settings_scene.instantiate() as Control
		settings.process_mode = Node.PROCESS_MODE_ALWAYS
		
		settings.connect("back_requested", _on_settings_back_requested)
		get_parent().add_child(settings)
	hide()
	settings.show()

func _on_settings_back_requested() -> void:
	settings.hide()
	show()

func _on_exit_pressed() -> void:
	get_tree().quit()
	
func pausemenu():
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused=false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.show()
		animation_player.play("open")
		get_tree().paused=true
	paused=!paused
