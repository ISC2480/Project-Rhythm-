extends Node3D


@onready var button1_anim: AnimationPlayer = $Button1PressAnim
@onready var button2_anim: AnimationPlayer = $Button2PressAnim
@onready var button3_anim: AnimationPlayer = $Button3PressAnim
@onready var button4_anim: AnimationPlayer = $Button4PressAnim

# References to each button's visible face.
@onready var button_faces: Array[MeshInstance3D] = [
	$"Project_Rhythm_Button1/world/03_Button_Face",
	$"Project_Rhythm_Button2/world/03_Button_Face",
	$"Project_Rhythm_Button3/world/03_Button_Face",
	$"Project_Rhythm_Button4/world/03_Button_Face"
]

# Stores the original material for each of the four TapButtons
# use this to restore their original colors when the player releases color switch key
var original_materials: Array[Material] = []

# No color has been selected yet
var selected_color: int = -1

# Runs once when the game starts
func _ready() -> void:

	# Save the original material of each TapButton
	for face in button_faces:

		# Save the current material override
		original_materials.append(face.material_override)


# Runs every frame
func _process(_delta: float) -> void:

	
	if Input.is_action_just_pressed("lane1"):
		button1_anim.play("Button1Press")

	if Input.is_action_just_pressed("lane2"):
		button2_anim.play("Button2Press")

	if Input.is_action_just_pressed("lane3"):
		button3_anim.play("Button3Press")

	if Input.is_action_just_pressed("lane4"):
		button4_anim.play("Button4Press")


	# Check whether the pink key is currently held
	var pink_held: bool = Input.is_key_pressed(
		Settings.color_key_bindings[Settings.NoteColor.COLOR_1]
	)

	# Check whether the cyan key is currently held
	var cyan_held: bool = Input.is_key_pressed(
		Settings.color_key_bindings[Settings.NoteColor.COLOR_2]
	)


	# Holding S changes all TapButtons to pink
	if pink_held and not cyan_held:
		switch_color(Settings.NoteColor.COLOR_1)

	# Holding L changes all TapButtons to cyan
	elif cyan_held and not pink_held:
		switch_color(Settings.NoteColor.COLOR_2)

	# When neither key is held, restore neutral colors
	elif not pink_held and not cyan_held:
		reset_button_colors()

	# If both are held, retain the current color


# Changes all TapButtons to the selected color
func switch_color(new_color: int) -> void:

	# Avoid applying the same color every frame
	if selected_color == new_color:
		return

	# Store the currently selected color
	selected_color = new_color

	# Get the selected pink or cyan color from settings
	var color_value: Color = Settings.noteColors[new_color]

	# Go through all four TapButton faces
	for face in button_faces:

		# Create a new material for the selected color
		var material := StandardMaterial3D.new()

		# Change the material's color
		material.albedo_color = color_value

		# Apply the material to the button face
		face.material_override = material


# Restores all four TapButtons to their original colors
func reset_button_colors() -> void:

	# Don't reset repeatedly when already neutral
	if selected_color == -1:
		return

	# Set the current color back to neutral
	selected_color = -1

	# Restore each button's original material
	for i in range(button_faces.size()):
		button_faces[i].material_override = original_materials[i]
