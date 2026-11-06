# Gives this script a reusable class name in Godot.
# Other scripts can access its enums using GodotxHealthBarEnums.
class_name GodotxHealthBarEnums


# =========================
# LABEL POSITION
# =========================

# An enum (enumeration) is a collection of named constant values.
# Each option represents a possible position for the health bar's text.
#
# Godot automatically assigns numbers starting at 0:
# TOP = 0, BOTTOM = 1, LEFT = 2, RIGHT = 3, CENTER_INSIDE = 4.
#
# Example:
# GodotxHealthBarEnums.LabelPosition.TOP
enum LabelPosition {

	# Display the label above the health bar.
	TOP,

	# Display the label below the health bar.
	BOTTOM,

	# Display the label to the left of the health bar.
	LEFT,

	# Display the label to the right of the health bar.
	RIGHT,

	# Display the label inside the health bar, centered.
	CENTER_INSIDE
}


# =========================
# ICON POSITION
# =========================

# Determines where an optional icon appears relative to the health bar.
#
# Example:
# GodotxHealthBarEnums.IconPosition.BEFORE
enum IconPosition {

	# Place the icon before the health bar (to its left).
	BEFORE,

	# Place the icon after the health bar (to its right).
	AFTER,

	# Place the icon above the health bar.
	ABOVE,

	# Place the icon below the health bar.
	BELOW,

	# Place the icon inside the left side of the health bar.
	INSIDE_LEFT,

	# Place the icon inside the right side of the health bar.
	INSIDE_RIGHT
}


# =========================
# GRADIENT DIRECTION
# =========================

# Determines the direction in which gradient colors transition.
#
# A gradient smoothly blends between two colors.
# The drawing script uses these options to select its drawing method.
enum GradientDirection {

	# Blend colors horizontally, from left to right.
	HORIZONTAL,

	# Blend colors vertically, from top to bottom.
	VERTICAL,

	# Select the diagonal direction starting from the top-left.
	DIAGONAL_TOP_LEFT,

	# Select the diagonal direction starting from the bottom-left.
	DIAGONAL_BOTTOM_LEFT
}


# =========================
# ANIMATION MODE
# =========================

# Determines how the health bar responds when its value changes.
#
# Example:
# GodotxHealthBarEnums.AnimationMode.TWEEN
enum AnimationMode {

	# Do not use a tween animation.
	# Health changes are displayed immediately.
	NONE,

	# Use a Tween to smoothly transition between health values.
	# For example, the bar can shrink gradually when taking damage.
	TWEEN
}


# =========================
# ICON FIT MODE
# =========================

# Determines how an icon texture is resized inside its rectangle.
#
# These options are used by draw_texture_fitted()
# in the health_bar_draw script.
enum IconFitMode {

	# Preserve the image's proportions.
	# Resize it so the entire image fits inside the rectangle.
	FIT,

	# Preserve the image's proportions.
	# Resize it until it covers the rectangle's dimensions.
	# Parts may extend outside the intended rectangle.
	FILL,

	# Resize the image to match the rectangle exactly.
	# Its original proportions may be distorted.
	STRETCH
}
