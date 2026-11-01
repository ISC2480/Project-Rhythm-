extends Node3D

@onready var button1_anim: AnimationPlayer = $Button1PressAnim



func _process(_delta):
	if Input.is_action_just_pressed("lane1"):
		button1_anim.play("Button1Press")
