extends Node3D

@onready var button1_anim: AnimationPlayer = $Button1PressAnim

func _ready():
	print("TapButtons script is running!")

func _process(_delta):
	if Input.is_action_just_pressed("lane1"):
		print("D key detected!")
		button1_anim.play("Button1Press")
