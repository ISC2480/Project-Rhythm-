
extends CanvasLayer

# Reference to the GodotX health bar in our HUD scene.
@onready var health_bar = $Healthbar

# Updates the player's health displayed on the HUD.
# Other scripts can call this function later.
func set_health(amount: float) -> void:
	# Keep health between 0 and 100.
	# Prevents negative health or values above maximum health.
	health_bar.value = clampf(amount, 0.0, 100.0)

	#BLOCK HAS BEEN COMMENTED OUT BUT KEPT FOR DEBUG REASONS
## Temporary test to simulate losing health.
## This does not require the note judgment system.
#func _ready() -> void:
	#set_health(100.0)
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(75.0)
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(50.0)
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(25.0)
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(0.0)
	#BLOCK HAS BEEN COMMENTED OUT BUT KEPT FOR DEBUG REASONS
	
	# Reference to the judgment UI container and text.
@onready var judgment_container = $JudementContainer
@onready var judgment_display = $JudementContainer/JudgmentDisplay
# Displays a judgment temporarily.
func show_judgment(judgment: String) -> void:

	# Update the displayed text.
	judgment_display.text = judgment

	# Show the box and text together.
	judgment_container.show()

	# Keep the judgment visible for 0.75 seconds.
	await get_tree().create_timer(0.75).timeout

	# Hide the judgment UI again.
	judgment_container.hide()

func _ready() -> void: #TIMER DEBUG THAT SPAWNS THE JUDMENT UI ELEMENT
	await get_tree().create_timer(1.0).timeout
	show_judgment("MISS")
	
	await get_tree().create_timer(1.5).timeout
	show_judgment("GOOD")
	
	await get_tree().create_timer(2.0).timeout
	show_judgment("GREAT")
	
	await get_tree().create_timer(2.5).timeout
	show_judgment("PERFECT")
