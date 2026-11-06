# Gives this script a reusable class name in Godot.
class_name GodotxHealthBarControl

# Control is the base class for UI elements.
# Unlike Node2D, Control supports UI layouts, anchors, and containers.
extends Control


# =========================
# SIGNALS
# =========================

# Signals announce events that other scripts can listen for.
# These signals track the beginning, progress, and end of health changes.
signal value_change_started(from_value: float, to_value: float)
signal value_changed(new_value: float)
signal value_change_finished(final_value: float)


# =========================
# INTERNAL VARIABLES
# =========================

# Stores the current health value, minimum, and maximum.
var _value: float = 100.0
var _min_value: float = 0.0
var _max_value: float = 100.0

# Stores the health percentage currently displayed on screen.
# This can differ from _value while an animation is playing.
var _display_value: float = 100.0

# Stores the Resource containing appearance and animation settings.
var _style: GodotxHealthBarStyle

# Stores the Tween responsible for smooth health animations.
var _tween: Tween

# A flag indicating that drawing-related data needs updating.
var _dirty: bool = true

# Rect2 stores a rectangle's position and size.
# These variables remember the different areas of the health bar.
var _cached_bar_rect: Rect2
var _cached_inner_rect: Rect2
var _cached_fill_rect: Rect2

# Stores optional label text and an instantiated icon node.
var _label_text: String = ""
var _icon_instance: Node


# =========================
# EXPORTED PROPERTIES
# =========================

# @export makes this property editable in Godot's Inspector.
# This property determines the health bar's appearance.
@export var style: GodotxHealthBarStyle:

	# The setter runs when a new style is assigned.
	set(v):

		# Use the provided style if it exists.
		if v:
			_style = v
		else:
			# Otherwise, use the default style.
			_style = _get_default_style()

		# Mark the drawing data as needing an update.
		_dirty = true

		# Recalculate the rectangles if the Control has valid dimensions.
		if size.x > 0 and size.y > 0:
			_resize_bar_rects()

		# Ask Godot to redraw the health bar.
		queue_redraw()

	# The getter runs when another script reads the style property.
	get:
		return _style if _style else _get_default_style()


# Exposes the health value in the Inspector.
@export var value: float = 100.0:

	# When health is assigned, call set_value().
	# true requests animation when the style allows it.
	set(v):
		set_value(v, true)

	# Return the internally stored health percentage.
	get:
		return _value


# Minimum health value.
@export var min_value: float = 0.0:
	set(v):
		_min_value = v
		_dirty = true
		queue_redraw()
	get:
		return _min_value


# Maximum health value.
@export var max_value: float = 100.0:
	set(v):
		_max_value = v
		_dirty = true
		queue_redraw()
	get:
		return _max_value


# =========================
# DEFAULT STYLE
# =========================

# Returns the existing style or creates a new default style.
func _get_default_style() -> GodotxHealthBarStyle:

	# If a style already exists, reuse it.
	if _style != null:
		return _style

	# Create a new Resource containing the default appearance settings.
	_style = GodotxHealthBarStyle.new()

	# Return the newly created style.
	return _style


# =========================
# INITIALIZATION
# =========================

# _init() runs when the object is first created.
func _init() -> void:

	# Sets the preferred minimum size of this UI element.
	custom_minimum_size = Vector2(120, 24)

	# Prevents this health bar from intercepting mouse input.
	# Mouse interactions can pass through to other UI elements.
	mouse_filter = MOUSE_FILTER_IGNORE

	# Create a default style if one has not been assigned.
	if _style == null:
		_style = GodotxHealthBarStyle.new()


# _ready() runs when the node is ready inside the scene tree.
func _ready() -> void:

	# Make sure a style exists.
	if not style:
		_style = GodotxHealthBarStyle.new()

	# Check color thresholds if threshold coloring is enabled.
	if style.use_threshold_colors:
		style.validate_thresholds()

	# Calculate the rectangles used to draw the health bar.
	_resize_bar_rects()

	# Request the initial drawing.
	queue_redraw()


# =========================
# RESIZE NOTIFICATION
# =========================

# Godot calls _notification() when certain events occur.
# The integer "what" identifies which event happened.
func _notification(what: int) -> void:

	# Check whether the Control has been resized.
	if what == NOTIFICATION_RESIZED:

		# Mark the drawing data as needing an update.
		_dirty = true

		# Recalculate the rectangles using the new dimensions.
		_resize_bar_rects()

		# Redraw the bar with its updated size.
		queue_redraw()


# =========================
# RECTANGLE CALCULATIONS
# =========================

# Calculates the different rectangles used by the health bar.
#
# These include:
# 1. The entire bar.
# 2. The inner area.
# 3. The filled portion representing health.
func _resize_bar_rects() -> void:

	# Read the current size of this Control.
	var sz = size

	# Stop if the Control has no drawable dimensions.
	if sz.x <= 0 or sz.y <= 0:
		return

	# Get the current style settings.
	var st = style

	# Use the configured border thickness if borders are enabled.
	# Otherwise, use zero.
	var border = st.border_thickness if st.border_enabled else 0

	# Get the spacing between the bar's outer and inner areas.
	var inset = st.fill_inset

	# If both inset values are zero, use the border thickness.
	if inset.x == 0 and inset.y == 0:
		inset = Vector2(border, border)

	# Create the rectangle representing the entire Control.
	# Vector2.ZERO means the rectangle begins at position (0, 0).
	_cached_bar_rect = Rect2(Vector2.ZERO, sz)

	# Calculate the rectangle inside the border and inset.
	_cached_inner_rect = Rect2(
		Vector2(border + inset.x, border + inset.y),
		sz - Vector2((border + inset.x) * 2, (border + inset.y) * 2)
	)

	# Prevent the inner rectangle from having negative dimensions.
	if _cached_inner_rect.size.x < 0 or _cached_inner_rect.size.y < 0:
		_cached_inner_rect.size = Vector2.ZERO

	# Recalculate how much of the inner rectangle is filled.
	_update_fill_rect()


# =========================
# FILLED AREA CALCULATION
# =========================

# Calculates the width of the filled portion of the health bar.
# The fill becomes wider or narrower depending on displayed health.
func _update_fill_rect() -> void:

	# Retrieve the previously calculated inner rectangle.
	var r = _cached_inner_rect

	# If the inner area has no drawable dimensions,
	# store it and stop calculating.
	if r.size.x <= 0 or r.size.y <= 0:
		_cached_fill_rect = r
		return

	# Calculate the fraction of the available health range.
	# clampf keeps the result between 0 and 1.
	# maxf prevents the denominator from becoming zero or smaller.
	var t = clampf((_display_value - min_value) / maxf(0.001, max_value - min_value), 0, 1)

	# Convert the fraction into a percentage.
	var norm = t * 100.0

	# Convert that percentage back into a fraction from 0 to 1.
	t = clampf(norm / 100.0, 0, 1)

	# Multiply the inner rectangle's width by the health fraction.
	# Its height stays unchanged.
	_cached_fill_rect = Rect2(r.position, Vector2(r.size.x * t, r.size.y))


# =========================
# CHANGE HEALTH VALUE
# =========================

# This is the main function used to update the health bar.
#
# v is the new health value.
# animate determines whether the change should be animated.
#
# Example:
# health_bar.set_value(75.0, true)
func set_value(v: float, animate: bool = true) -> void:

	# Calculate the difference between maximum and minimum health.
	var range_ok = max_value - min_value

	# Check for an invalid health range.
	if range_ok <= 0:

		# Display a warning in Godot.
		push_warning("GodotX Health Bar: max_value <= min_value")

		# Use 100 as a fallback range.
		range_ok = 100.0

	# Convert the incoming health value to a percentage from 0 to 100.
	var normalized = clampf((v - min_value) / range_ok * 100.0, 0, 100.0)

	# Remember the previous health percentage.
	var prev = _value

	# Store the new health percentage.
	_value = normalized

	# Check whether animation should be used.
	# All three conditions must be true:
	# Animation was requested, enabled, and set to TWEEN mode.
	var use_animate = animate and style.animation_enabled and style.animation_mode == GodotxHealthBarEnums.AnimationMode.TWEEN

	# Animate only when the difference exceeds the snap threshold.
	if use_animate and abs(_display_value - _value) > style.animation_snap_threshold:

		# Announce that a health animation is beginning.
		value_change_started.emit(prev, _value)

		# Stop an existing Tween if one is still active.
		if _tween and _tween.is_valid():
			_tween.kill()

		# Create a new Tween for the animation.
		_tween = create_tween()

		# Read the default animation settings.
		var dur = style.animation_duration
		var ease = style.animation_easing
		var trans = style.animation_transition

		# If health is decreasing and separate decrease settings exist,
		# use those settings instead of the defaults.
		if _value < _display_value and style.animation_duration_decrease >= 0:
			dur = style.animation_duration_decrease
			ease = style.animation_easing_decrease
			trans = style.animation_transition_decrease

		# Configure how the animation accelerates and transitions.
		_tween.set_ease(ease)
		_tween.set_trans(trans)

		# Gradually call _set_display_value() with changing values.
		# The transition begins at _display_value and ends at _value.
		_tween.tween_method(_set_display_value, _display_value, _value, dur)

		# Call this function after the animation finishes.
		_tween.tween_callback(_on_animation_finished)

	# If animation is not being used, update immediately.
	else:
		_set_display_value(_value)
		value_changed.emit(_value)
		queue_redraw()


# =========================
# UPDATE DISPLAYED HEALTH
# =========================

# Updates the health percentage currently visible on screen.
# Tween animations call this repeatedly with intermediate values.
func _set_display_value(v: float) -> void:

	# Keep the displayed percentage between 0 and 100.
	_display_value = clampf(v, 0, 100.0)

	# Recalculate the filled rectangle.
	_update_fill_rect()

	# Notify connected scripts of the displayed value.
	value_changed.emit(_display_value)

	# Request a redraw.
	queue_redraw()


# Called after the Tween completes its animation.
func _on_animation_finished() -> void:

	# Announce the final displayed health percentage.
	value_change_finished.emit(_display_value)


# Returns the internally stored health percentage.
func get_value() -> float:
	return _value


# =========================
# DRAW HEALTH BAR
# =========================

# Godot calls _draw() whenever the Control needs to be drawn.
# This function handles the main visual appearance of the health bar.
func _draw() -> void:

	# Get the appearance settings.
	var st = style

	# Stop if no style exists.
	if not st:
		return

	# Update the rectangles before drawing.
	_resize_bar_rects()

	# Retrieve the rectangles calculated earlier.
	var bar_rect = _cached_bar_rect
	var inner_rect = _cached_inner_rect
	var fill_rect = _cached_fill_rect

	# Prevent negative inner dimensions.
	if inner_rect.size.x < 0 or inner_rect.size.y < 0:
		inner_rect.size = Vector2.ZERO

	# Stop if the entire bar has no drawable area.
	if bar_rect.size.x <= 0 or bar_rect.size.y <= 0:
		return

	# Calculate the corner radius from the style settings.
	var radius = st.get_effective_round_radius(inner_rect.size.y)

	# Determine the border thickness.
	var border = st.border_thickness if st.border_enabled else 0


	# =========================
	# DRAW SHADOW
	# =========================

	# Only draw shadows if they are enabled.
	if st.shadow_enabled:

		# Read where the shadow should appear.
		var apply = st.shadow_apply_to

		# Apply shadow to the background when selected.
		if apply == 1 or apply == 3:
			GodotxHealthBarDraw.draw_shadow_approximate(self, bar_rect, radius + border, st.shadow_color, st.shadow_offset, maxi(1, st.shadow_blur_passes))

		# Apply shadow to the filled area when selected.
		if apply == 2 or apply == 3:
			GodotxHealthBarDraw.draw_shadow_approximate(self, fill_rect, radius, st.shadow_color, st.shadow_offset, maxi(1, st.shadow_blur_passes))


	# =========================
	# DRAW BORDER
	# =========================

	# Draw the border if it is enabled in the style.
	if st.border_enabled:
		GodotxHealthBarDraw.draw_rounded_rect_stroke(self, bar_rect, st.border_color, float(st.border_thickness), radius + border, st.border_join_round, st.background_color)


	# =========================
	# DRAW BACKGROUND AND FILL
	# =========================

	# Draw the empty background of the health bar.
	if inner_rect.size.x > 0 and inner_rect.size.y > 0:
		GodotxHealthBarDraw.draw_rounded_rect_filled(self, inner_rect, st.background_color, radius)

	# Choose the fill color based on the current displayed health.
	var fill_color = st.get_fill_color_for_value(_display_value)

	# Draw the filled portion if it has valid dimensions.
	if fill_rect.size.x > 0 and fill_rect.size.y > 0:
		GodotxHealthBarDraw.draw_rounded_rect_filled(self, fill_rect, fill_color, radius)

	# Otherwise, try calculating the fill width directly.
	elif inner_rect.size.x > 0 and inner_rect.size.y > 0:

		# Calculate the width using the current health fraction.
		var fill_w = inner_rect.size.x * clampf((_display_value - min_value) / maxf(0.001, max_value - min_value), 0, 1)

		# Draw only when there is a positive fill width.
		if fill_w > 0:
			GodotxHealthBarDraw.draw_rounded_rect_filled(self, Rect2(inner_rect.position, Vector2(fill_w, inner_rect.size.y)), fill_color, radius)


	# =========================
	# DRAW GRADIENT
	# =========================

	# Add a gradient overlay if enabled.
	if st.gradient_enabled:

		# Read where the gradient should be applied.
		var g_apply = st.gradient_apply_to

		# Apply gradient to the background.
		if g_apply == 1 or g_apply == 3:
			GodotxHealthBarDraw.draw_gradient_overlay(self, inner_rect, radius, st)

		# Apply gradient to the filled portion.
		if g_apply == 2 or g_apply == 3:
			GodotxHealthBarDraw.draw_gradient_overlay(self, fill_rect, radius, st)


	# Draw any enabled text label.
	_draw_label(bar_rect, inner_rect)

	# Draw any enabled icon.
	_draw_icon(bar_rect, inner_rect)


# =========================
# DRAW TEXT LABEL
# =========================

# Draws optional health text, such as "75%".
func _draw_label(bar_rect: Rect2, inner_rect: Rect2) -> void:

	# Get the current style.
	var st = style

	# Stop if labels are disabled.
	if not st.label_enabled:
		return

	# Generate the text using the configured label format.
	var text = _format_label(st)

	# Use the custom font if available.
	# Otherwise, use Godot's fallback font.
	var font_to_use: Font = st.font if st.font else ThemeDB.fallback_font

	# Try the Control's theme font if no font was found.
	if font_to_use == null:
		font_to_use = get_theme_default_font()

	# Stop if no font is available.
	if font_to_use == null:
		return

	# Ensure the font size is at least 8.
	var font_size = maxi(8, st.font_size)

	# Measure the text dimensions.
	var ts = font_to_use.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

	# Get the distance from the text baseline to the font's top.
	var ascent = font_to_use.get_ascent(font_size)

	# This variable will store the final text position.
	var pos: Vector2

	# Select the position based on the style's label setting.
	match st.label_position:

		# Place text above the health bar.
		GodotxHealthBarEnums.LabelPosition.TOP:
			pos = Vector2(bar_rect.position.x + bar_rect.size.x * 0.5 - ts.x * 0.5, bar_rect.position.y - ts.y - st.label_offset.y) + st.label_offset

		# Place text below the health bar.
		GodotxHealthBarEnums.LabelPosition.BOTTOM:
			pos = Vector2(bar_rect.position.x + bar_rect.size.x * 0.5 - ts.x * 0.5, bar_rect.end.y + st.label_offset.y) + Vector2(st.label_offset.x, 0)

		# Place text to the left.
		GodotxHealthBarEnums.LabelPosition.LEFT:
			pos = Vector2(bar_rect.position.x - ts.x - st.label_offset.x, bar_rect.position.y + bar_rect.size.y * 0.5 - ts.y * 0.5) + Vector2(0, st.label_offset.y)

		# Place text to the right.
		GodotxHealthBarEnums.LabelPosition.RIGHT:
			pos = Vector2(bar_rect.end.x + st.label_offset.x, bar_rect.position.y + bar_rect.size.y * 0.5 - ts.y * 0.5) + Vector2(0, st.label_offset.y)

		# Center the text inside the health bar.
		GodotxHealthBarEnums.LabelPosition.CENTER_INSIDE:
			pos = inner_rect.position + (inner_rect.size - ts) * 0.5 + st.label_offset

		# Default to the centered position.
		_:
			pos = inner_rect.position + (inner_rect.size - ts) * 0.5 + st.label_offset

	# Adjust the vertical position to account for the font baseline.
	pos.y += ascent

	# Get the CanvasItem identifier needed to draw text.
	var crid = get_canvas_item()

	# Stop if the CanvasItem is invalid.
	if not crid.is_valid():
		return

	# Draw an outline around the text when enabled.
	if st.outline_size > 0:
		font_to_use.draw_string_outline(crid, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, st.outline_size, st.outline_color)

	# Draw a shadow behind the text when enabled.
	if st.label_shadow_enabled:
		font_to_use.draw_string(crid, pos + st.label_shadow_offset, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, st.label_shadow_color)

	# Draw the actual text using the configured font color.
	font_to_use.draw_string(crid, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, st.font_color)


# =========================
# FORMAT LABEL TEXT
# =========================

# Converts the displayed health percentage into formatted text.
#
# Example:
# A label format of "{value}%" can produce "75%".
func _format_label(st: GodotxHealthBarStyle) -> String:

	# Read the current displayed percentage.
	var v = _display_value

	# Read the optional custom maximum.
	var mx = st.label_custom_max

	# If the format contains {max}, scale the percentage
	# to the custom maximum. Otherwise, use the percentage.
	var num_val: float = (v / 100.0) * mx if st.label_format.contains("{max}") else v

	# Replace placeholders with their calculated numeric values.
	return st.label_format.replace("{value}", str(int(roundf(num_val)))).replace("{max}", str(int(mx)))


# =========================
# DRAW ICON
# =========================

# Draws an optional image or scene near the health bar.
func _draw_icon(bar_rect: Rect2, inner_rect: Rect2) -> void:

	# Get the current style settings.
	var st = style

	# Stop if icons are disabled.
	if not st.icon_enabled:
		return

	# Determine a default icon size using the bar's height.
	var default_icon_size = maxf(inner_rect.size.y, 16)

	# Read the configured icon dimensions.
	var sz = st.icon_forced_size

	# Use the default dimensions if the configured size is invalid.
	if sz.x <= 0 or sz.y <= 0:
		sz = Vector2(default_icon_size, default_icon_size)

	# Read any additional icon positioning offset.
	var offset = st.icon_offset

	# This variable will hold the icon's final position.
	var pos: Vector2

	# Determine where the icon should appear.
	match st.icon_position:

		# Position the icon before the health bar.
		GodotxHealthBarEnums.IconPosition.BEFORE:
			pos = Vector2(bar_rect.position.x - sz.x + offset.x, bar_rect.position.y + bar_rect.size.y * 0.5 - sz.y * 0.5 + offset.y)

		# Position the icon after the health bar.
		GodotxHealthBarEnums.IconPosition.AFTER:
			pos = Vector2(bar_rect.end.x + offset.x, bar_rect.position.y + bar_rect.size.y * 0.5 - sz.y * 0.5 + offset.y)

		# Position the icon above the health bar.
		GodotxHealthBarEnums.IconPosition.ABOVE:
			pos = Vector2(bar_rect.position.x + bar_rect.size.x * 0.5 - sz.x * 0.5 + offset.x, bar_rect.position.y - sz.y + offset.y)

		# Position the icon below the health bar.
		GodotxHealthBarEnums.IconPosition.BELOW:
			pos = Vector2(bar_rect.position.x + bar_rect.size.x * 0.5 - sz.x * 0.5 + offset.x, bar_rect.end.y + offset.y)

		# Position the icon inside the left side.
		GodotxHealthBarEnums.IconPosition.INSIDE_LEFT:
			pos = inner_rect.position + offset

		# Position the icon inside the right side.
		GodotxHealthBarEnums.IconPosition.INSIDE_RIGHT:
			pos = Vector2(inner_rect.end.x - sz.x, inner_rect.position.y) + offset

		# Default position if no other option matches.
		_:
			pos = bar_rect.position + offset

	# Create a rectangle describing the icon's position and size.
	var icon_rect = Rect2(pos, sz)

	# If an icon texture exists, draw that image.
	if st.icon_texture:
		GodotxHealthBarDraw.draw_texture_fitted(self, icon_rect, st.icon_texture, st.icon_tint, st.icon_fit_mode)

	# Otherwise, instantiate an icon scene if one exists
	# and an icon instance has not already been created.
	elif st.icon_scene and _icon_instance == null:

		# Create an instance of the configured scene.
		var inst = st.icon_scene.instantiate()

		# If the scene's root is a Control, set its position and size.
		if inst is Control:
			inst.position = pos
			inst.size = sz
			add_child(inst)
			_icon_instance = inst

		# Reject other scene root types in this implementation.
		else:
			push_error("GodotX Health Bar: icon_scene root must be a Control or Node2D")

			# Delete the invalid instance if it exists.
			if is_instance_valid(inst):
				inst.queue_free()

	# If no texture or new scene instance is used,
	# draw a simple placeholder icon using rounded rectangles.
	else:

		# Draw the outer portion of the placeholder icon.
		GodotxHealthBarDraw.draw_rounded_rect_filled(self, icon_rect, Color(st.icon_tint.r, st.icon_tint.g, st.icon_tint.b, 0.6), minf(4, minf(sz.x, sz.y) * 0.5))

		# Draw the smaller inner portion of the placeholder icon.
		GodotxHealthBarDraw.draw_rounded_rect_filled(self, Rect2(icon_rect.position + Vector2(2, 2), icon_rect.size - Vector2(4, 4)), st.icon_tint, minf(2, minf(sz.x, sz.y) * 0.25))
