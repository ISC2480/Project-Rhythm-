extends Node3D

@onready var button1_anim: AnimationPlayer = $Button1PressAnim
@onready var button2_anim: AnimationPlayer = $Button2PressAnim
@onready var button3_anim: AnimationPlayer = $Button3PressAnim
@onready var button4_anim: AnimationPlayer = $Button4PressAnim
func _process(_delta):
	if Input.is_action_just_pressed("lane1"):
		button1_anim.play("Button1Press")
	if Input.is_action_just_pressed("lane2"):
		button2_anim.play("Button2Press")
	if Input.is_action_just_pressed("lane3"):
		button3_anim.play("Button3Press")
	if Input.is_action_just_pressed("lane4"):
		button4_anim.play("Button4Press")
