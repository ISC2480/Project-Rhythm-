extends CanvasLayer

# =========================
# NODE REFERENCES
# =========================

# Reference to the GodotX health bar in our HUD scene.
@onready var health_bar = $Healthbar

# References to the judgment UI container and text.
@onready var judgment_container = $JudementContainer
@onready var judgment_display = $JudementContainer/JudgmentDisplay


# =========================
# HEALTH SYSTEM
# =========================

# Updates the player's health displayed on the HUD.
# Other scripts can call this function later.
func set_health(amount: float) -> void:

	# Keep health between 0 and 100.
	# Prevents negative health or values above maximum health.
	health_bar.value = clampf(amount, 0.0, 100.0)


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

	# Hide the judgment UI initially.
	judgment_container.hide()

	# Start both tests independently.
	# Neither function needs to wait for the other to finish.
	test_health()
	test_judgments()


# =========================
# HEALTH BAR TEST
# =========================

# Temporary test to simulate losing health.
# This does not require the note judgment system.
func test_health() -> void:

	await get_tree().create_timer(2.0).timeout
	set_health(70.0)

	await get_tree().create_timer(2.0).timeout
	set_health(85.0)

	await get_tree().create_timer(2.0).timeout
	set_health(90.0)

	await get_tree().create_timer(2.0).timeout
	set_health(100.0)


# =========================
# JUDGMENT MESSAGE TEST
# =========================

# Temporary test that displays different judgment messages.
func test_judgments() -> void:

	await get_tree().create_timer(2.0).timeout
	await show_judgment("MISS")

	await get_tree().create_timer(1.35).timeout
	await show_judgment("GOOD")

	await get_tree().create_timer(1.25).timeout
	await show_judgment("GREAT")

	await get_tree().create_timer(.80).timeout
	await show_judgment("PERFECT")
