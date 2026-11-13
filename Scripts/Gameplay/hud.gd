extends CanvasLayer

# =========================
# NODE REFERENCES
# =========================

# Reference to the GodotX health bar in our HUD scene.
@onready var health_bar = $Healthbar
# Current player health.
var current_health: float = 100.0

# References to the judgment UI container and text.
@onready var judgment_container = $JudementContainer
@onready var judgment_display = $JudementContainer/JudgmentDisplay


# =========================
# HEALTH SYSTEM
# =========================

# Updates the player's health.
func set_health(amount: float) -> void:

	# Prevent health from going below 0 or above 100.
	current_health = clampf(amount, 0.0, 100.0)

	# Update the visible health bar.
	health_bar.value = current_health


# Changes health based on the player's judgment.
func apply_judgment_health(judgment: String) -> void:

	match judgment:
		"MISS":
			set_health(current_health - 10.0)

		"GOOD":
			set_health(current_health + 2.0)

		"GREAT":
			set_health(current_health + 4.0)

		"PERFECT":
			set_health(current_health + 6.0)

	# Print health for debugging.
	print("Current Health: ", current_health)


# =========================
# JUDGMENT SYSTEM
# =========================

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


# =========================
# START BOTH TESTS
# =========================

# Runs automatically when the HUD enters the scene.
func _ready() -> void:

	# Start with full health.
	set_health(100.0)

	# Hide judgment messages until a note is judged.
	judgment_container.hide()

	# Temporary tests disabled.
	# The gameplay system now controls judgment messages.
	# test_health()
	# test_judgments()


# =========================
# HEALTH BAR TEST
# =========================

# Temporary test to simulate losing health.
# This does not require the note judgment system.
#func test_health() -> void:
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(70.0)
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(85.0)
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(90.0)
#
	#await get_tree().create_timer(2.0).timeout
	#set_health(100.0)


# =========================
# JUDGMENT MESSAGE TEST
# =========================

# Temporary test that displays different judgment messages.
#func test_judgments() -> void:
#
	#await get_tree().create_timer(2.0).timeout
	#await show_judgment("MISS")
#
	#await get_tree().create_timer(1.35).timeout
	#await show_judgment("GOOD")
#
	#await get_tree().create_timer(1.25).timeout
	#await show_judgment("GREAT")
#
	#await get_tree().create_timer(.80).timeout
	#await show_judgment("PERFECT")
