# Allows this script to run inside the Godot editor, not just during gameplay.
@tool

# Gives this Resource a reusable class name throughout the project.
class_name GodotxHealthBarStyle

# Resource stores settings and data that other scripts can use.
# This script controls how a health bar looks and animates.
extends Resource


# =========================
# BAR GEOMETRY
# =========================

# Groups the following settings under "Bar Geometry" in the Inspector.
@export_group("Bar Geometry")

# Controls how rounded the corners of the health bar are.
# @export_range creates a slider from 0 to 100, increasing by 0.5.
@export_range(0.0, 100.0, 0.5) var roundness: float = 20.0

# Controls the spacing between the fill and the surrounding bar.
# Vector2 stores two values: X (horizontal) and Y (vertical).
@export var fill_inset: Vector2 = Vector2(2, 2)


# =========================
# COLORS
# =========================

# These settings determine the health bar's colors.
@export_group("Colors")

# Color uses RGBA: red, green, blue, and alpha (transparency).
# Each component normally ranges from 0.0 to 1.0.

# Color of the empty area behind the health fill.
@export var background_color: Color = Color(0.2, 0.2, 0.22, 1.0)

# Default color of the filled portion of the health bar.
@export var fill_color: Color = Color(0.25, 0.65, 0.35, 1.0)

# Determines whether health percentage changes the fill color.
@export var use_threshold_colors: bool = false

# Health at or below 10 uses the red color.
@export var threshold_red_max: float = 10.0

# Health above the red threshold and at or below 70 uses orange.
@export var threshold_orange_max: float = 70.0

# Colors used when threshold coloring is enabled.
@export var color_red: Color = Color(0.9, 0.25, 0.2, 1.0)
@export var color_orange: Color = Color(0.95, 0.6, 0.15, 1.0)
@export var color_green: Color = Color(0.25, 0.75, 0.35, 1.0)


# =========================
# BORDER
# =========================

# Controls the outline surrounding the health bar.
@export_group("Border")

# Whether the border is visible.
@export var border_enabled: bool = true

# Thickness of the border in pixels.
@export var border_thickness: int = 2

# Color of the border.
@export var border_color: Color = Color(0.4, 0.4, 0.45, 1.0)

# Controls whether border joins are rounded.
@export var border_join_round: bool = true


# =========================
# SHADOW
# =========================

# Shadows can help separate the health bar from the background.
@export_group("Shadow")

# Enables or disables the shadow.
@export var shadow_enabled: bool = false

# Shadow color, with 0.35 alpha making it partially transparent.
@export var shadow_color: Color = Color(0, 0, 0, 0.35)

# Moves the shadow 2 pixels right and 3 pixels down.
@export var shadow_offset: Vector2 = Vector2(2, 3)

# Number of passes used to approximate a blurred shadow.
@export var shadow_blur_passes: int = 3

# Determines where the shadow is applied.
# 1 = background, 2 = fill, 3 = both.
@export var shadow_apply_to: int = 2


# =========================
# GRADIENT
# =========================

# A gradient blends between two colors.
@export_group("Gradient")

# Enables or disables the gradient effect.
@export var gradient_enabled: bool = false

# Determines the direction in which the colors blend.
# The available directions are defined in GodotxHealthBarEnums.
@export var gradient_direction: GodotxHealthBarEnums.GradientDirection = GodotxHealthBarEnums.GradientDirection.HORIZONTAL

# Color used at the beginning of the gradient.
@export var gradient_start_color: Color = Color(1, 1, 1, 0.25)

# Color used at the end of the gradient.
@export var gradient_end_color: Color = Color(0, 0, 0, 0.2)

# Controls gradient intensity from 0 to 1.
@export_range(0.0, 1.0, 0.05) var gradient_intensity: float = 1.0

# Determines where the gradient appears.
# 1 = background, 2 = fill, 3 = both.
@export var gradient_apply_to: int = 1


# =========================
# LABEL
# =========================

# These settings control optional text displayed with the bar.
@export_group("Label")

# Determines whether the label is shown.
@export var label_enabled: bool = false

# Determines where the label appears relative to the health bar.
@export var label_position: GodotxHealthBarEnums.LabelPosition = GodotxHealthBarEnums.LabelPosition.CENTER_INSIDE

# Moves the label horizontally or vertically.
@export var label_offset: Vector2 = Vector2.ZERO

# Text format for the label.
# {value} is replaced with the current displayed health value.
@export var label_format: String = "{value}%"

# Custom maximum used when formatting labels containing {max}.
@export var label_custom_max: float = 100.0

# Optional custom font for the label.
@export var font: Font

# Font size in pixels.
@export var font_size: int = 14

# Main color of the label text.
@export var font_color: Color = Color(1, 1, 1, 1.0)

# Thickness of the outline around the text.
# Zero means no outline.
@export var outline_size: int = 0

# Color used for the text outline.
@export var outline_color: Color = Color(0, 0, 0, 1.0)

# Enables or disables a shadow behind the text.
@export var label_shadow_enabled: bool = false

# Position of the text shadow relative to the text.
@export var label_shadow_offset: Vector2 = Vector2(1, 1)

# Color and transparency of the text shadow.
@export var label_shadow_color: Color = Color(0, 0, 0, 0.5)


# =========================
# ICON
# =========================

# Icons can appear beside or inside the health bar.
@export_group("Icon")

# Determines whether an icon is displayed.
@export var icon_enabled: bool = false

# An optional image used as the icon.
@export var icon_texture: Texture2D

# An optional scene that can be instantiated as the icon.
@export var icon_scene: PackedScene

# Determines where the icon is positioned.
@export var icon_position: GodotxHealthBarEnums.IconPosition = GodotxHealthBarEnums.IconPosition.BEFORE

# Additional horizontal and vertical positioning for the icon.
@export var icon_offset: Vector2 = Vector2.ZERO

# Desired icon width and height.
@export var icon_forced_size: Vector2 = Vector2(24, 24)

# Determines how an icon texture fits into its rectangle.
@export var icon_fit_mode: GodotxHealthBarEnums.IconFitMode = GodotxHealthBarEnums.IconFitMode.FIT

# Color tint applied to the icon.
# Color.WHITE preserves the icon's original colors.
@export var icon_tint: Color = Color.WHITE


# =========================
# ANIMATION
# =========================

# These settings control how smoothly health changes are displayed.
@export_group("Animation")

# Determines whether changes to the health bar can be animated.
@export var animation_enabled: bool = true

# Selects the animation method.
# TWEEN smoothly changes a value over time.
@export var animation_mode: GodotxHealthBarEnums.AnimationMode = GodotxHealthBarEnums.AnimationMode.TWEEN

# Default animation duration in seconds.
@export var animation_duration: float = 0.25

# Easing controls how the animation accelerates or slows.
# EASE_OUT makes the animation slow down toward the end.
@export var animation_easing: Tween.EaseType = Tween.EASE_OUT

# Transition controls the mathematical curve of the animation.
# TRANS_QUAD uses a quadratic curve.
@export var animation_transition: Tween.TransitionType = Tween.TRANS_QUAD

# Optional separate duration when health decreases.
# -1 means the default duration will be used.
@export var animation_duration_decrease: float = -1.0

# Separate easing setting for decreasing health.
@export var animation_easing_decrease: Tween.EaseType = Tween.EASE_OUT

# Separate transition setting for decreasing health.
@export var animation_transition_decrease: Tween.TransitionType = Tween.TRANS_QUAD

# Minimum difference required before the main health bar script
# uses an animation instead of updating immediately.
@export var animation_snap_threshold: float = 0.0


# =========================
# CONSTANTS
# =========================

# Constants are named values that cannot be reassigned.
# They make numeric options easier to understand in other scripts.

# Options for where a shadow is applied.
const SHADOW_APPLY_BACKGROUND := 1
const SHADOW_APPLY_FILL := 2
const SHADOW_APPLY_BOTH := 3

# Options for where a gradient is applied.
const GRADIENT_APPLY_BACKGROUND := 1
const GRADIENT_APPLY_FILL := 2
const GRADIENT_APPLY_BOTH := 3


# =========================
# INSPECTOR PROPERTY VALIDATION
# =========================

# Godot calls this function when preparing properties for the Inspector.
# The Dictionary contains information about the property being inspected.
func _validate_property(property: Dictionary) -> void:

	# Check whether the property is the separate animation duration
	# used when health decreases.
	if property.name == "animation_duration_decrease":

		# Hide this property when animation is disabled.
		# Otherwise, allow it to appear normally in the Inspector.
		property.usage = PROPERTY_USAGE_NO_EDITOR if not animation_enabled else PROPERTY_USAGE_DEFAULT

	# Add a descriptive hint for the gradient target setting.
	if property.name == "gradient_apply_to":
		property.hint_string = "1=Background, 2=Fill, 3=Both"

	# Add a descriptive hint for the shadow target setting.
	if property.name == "shadow_apply_to":
		property.hint_string = "1=Background, 2=Fill, 3=Both"


# =========================
# HEALTH-BASED COLOR SELECTION
# =========================

# This function returns the color that should be used
# for a particular health percentage.
#
# Input: a health value from 0 to 100.
# Output: a Color.
func get_fill_color_for_value(value_0_100: float) -> Color:

	# If threshold coloring is disabled, use the default fill color.
	if not use_threshold_colors:
		return fill_color

	# Low health uses red.
	if value_0_100 <= threshold_red_max:
		return color_red

	# Medium health uses orange.
	if value_0_100 <= threshold_orange_max:
		return color_orange

	# Any value above the orange threshold uses green.
	return color_green


# =========================
# CORNER ROUNDNESS
# =========================

# Calculates the corner radius using the bar's height.
#
# A radius determines how curved the corners are.
# A larger radius produces rounder corners.
func get_effective_round_radius(bar_height: float) -> float:

	# Convert the roundness percentage into a pixel radius.
	var r = (roundness / 100.0) * bar_height

	# Limit the radius to half the bar's height.
	var max_r = bar_height * 0.5

	# minf returns the smaller of the two floating-point values.
	return minf(r, max_r)


# =========================
# THRESHOLD VALIDATION
# =========================

# Checks whether the red and orange thresholds have valid values.
# Invalid values produce error messages and are adjusted.
#
# The function returns a boolean, which is true or false.
func validate_thresholds() -> bool:

	# Check whether the red threshold is outside 0 to 100.
	if threshold_red_max < 0 or threshold_red_max > 100:

		# Display an error in Godot's debugger.
		push_error("GodotX Health Bar: threshold_red_max must be 0..100")

		# clampf restricts the value to the specified range.
		threshold_red_max = clampf(threshold_red_max, 0, 100)

	# Check whether the orange threshold is outside 0 to 100.
	if threshold_orange_max < 0 or threshold_orange_max > 100:

		# Report the invalid orange threshold.
		push_error("GodotX Health Bar: threshold_orange_max must be 0..100")

		# Restrict it to the allowed range.
		threshold_orange_max = clampf(threshold_orange_max, 0, 100)

	# The red threshold must be smaller than the orange threshold.
	if threshold_red_max >= threshold_orange_max:

		# Report the incorrect ordering.
		push_error("GodotX Health Bar: threshold_red_max must be < threshold_orange_max; correcting.")

		# Increase the orange threshold if necessary.
		# maxf chooses the larger floating-point value.
		threshold_orange_max = maxf(threshold_red_max + 1.0, threshold_orange_max)

	# Return true after completing the validation process.
	return true
