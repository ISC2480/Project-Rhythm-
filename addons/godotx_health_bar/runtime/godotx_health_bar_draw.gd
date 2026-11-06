# Gives this script a reusable class name in Godot.
class_name GodotxHealthBarDraw

# RefCounted is a lightweight base class for helper objects.
# This script contains drawing functions rather than a scene node.
extends RefCounted


# =========================
# ROUNDED RECTANGLE POLYGON
# =========================

# Creates a collection of points outlining a rounded rectangle.
#
# static means the function can be called directly from the class:
# GodotxHealthBarDraw.make_rounded_rect_polygon(...)
#
# rect contains the rectangle's position and size.
# radius determines how rounded its corners are.
# PackedVector2Array stores an array of 2D coordinate points.
static func make_rounded_rect_polygon(rect: Rect2, radius: float) -> PackedVector2Array:

	# Restrict the radius so it cannot be negative or exceed
	# half the rectangle's smallest dimension.
	var r = clampf(radius, 0, minf(rect.size.x, rect.size.y) * 0.5)

	# Extract the rectangle's starting X and Y coordinates.
	var x0 = rect.position.x
	var y0 = rect.position.y

	# Extract its width and height.
	var w = rect.size.x
	var h = rect.size.y

	# A rectangle with no positive width or height cannot be drawn.
	# Return an empty array of points.
	if w <= 0 or h <= 0:
		return PackedVector2Array()

	# Godot expects counter-clockwise order (interior on left when walking boundary).

	# If the radius is zero, the rectangle has square corners.
	# Only four points are needed to describe its outline.
	if r <= 0:
		return PackedVector2Array([
			Vector2(x0, y0),
			Vector2(x0, y0 + h),
			Vector2(x0 + w, y0 + h),
			Vector2(x0 + w, y0)
		])

	# Create an empty array that will hold the polygon's points.
	var pts: PackedVector2Array = []

	# More segments produce smoother-looking rounded corners.
	var steps = 12  # segments per 90° arc for smooth edges

	# Walk counter-clockwise: top (left->right), right (top->bottom), bottom (right->left), left (bottom->top).

	# Add the starting and ending points of the top straight edge.
	pts.append(Vector2(x0 + r, y0))
	pts.append(Vector2(x0 + w - r, y0))

	# Top-right arc: center (x0+w-r, y0+r), angle -PI/2 -> 0

	# Loop through 12 points along the top-right corner.
	for i in range(1, steps + 1):

		# Convert the current step into a fraction from 0 to 1.
		var t = float(i) / float(steps)

		# Calculate the angle of the current point.
		# PI represents approximately 3.14159 radians.
		var angle = -PI * 0.5 + (PI * 0.5) * t

		# cos() calculates the horizontal part of the arc.
		# sin() calculates the vertical part.
		pts.append(Vector2(x0 + w - r + r * cos(angle), y0 + r + r * sin(angle)))

	# Add the endpoint of the right straight edge.
	pts.append(Vector2(x0 + w, y0 + h - r))

	# Bottom-right arc: center (x0+w-r, y0+h-r), angle 0 -> PI/2

	# Generate points for the bottom-right rounded corner.
	for i in range(1, steps + 1):
		var t = float(i) / float(steps)
		var angle = (PI * 0.5) * t
		pts.append(Vector2(x0 + w - r + r * cos(angle), y0 + h - r + r * sin(angle)))

	# Add the endpoint of the bottom straight edge.
	pts.append(Vector2(x0 + r, y0 + h))

	# Bottom-left arc: center (x0+r, y0+h-r), angle PI/2 -> PI

	# Generate points for the bottom-left rounded corner.
	for i in range(1, steps + 1):
		var t = float(i) / float(steps)
		var angle = PI * 0.5 + (PI * 0.5) * t
		pts.append(Vector2(x0 + r + r * cos(angle), y0 + h - r + r * sin(angle)))

	# Add the endpoint of the left straight edge.
	pts.append(Vector2(x0, y0 + r))

	# Top-left arc: center (x0+r, y0+r), angle PI -> 3*PI/2

	# Generate points for the top-left rounded corner.
	for i in range(1, steps + 1):
		var t = float(i) / float(steps)
		var angle = PI + (PI * 0.5) * t
		pts.append(Vector2(x0 + r + r * cos(angle), y0 + r + r * sin(angle)))

	# Return all calculated points to the function that requested them.
	return pts


# =========================
# DRAW FILLED ROUNDED RECTANGLE
# =========================

# Draws a solid rounded rectangle onto a CanvasItem.
#
# CanvasItem is the base class used by Godot's 2D drawing system.
# color determines the rectangle's fill color.
static func draw_rounded_rect_filled(canvas: CanvasItem, rect: Rect2, color: Color, radius: float) -> void:

	# Generate the points that form the rounded rectangle.
	var pts = make_rounded_rect_polygon(rect, radius)

	# At least three points are required to form a polygon.
	if pts.size() < 3:
		return

	# Draw a solid polygon using the requested color.
	canvas.draw_colored_polygon(pts, color)


# =========================
# DRAW ROUNDED RECTANGLE BORDER
# =========================

# Draws a border by placing a smaller rectangle inside a larger one.
#
# The larger rectangle uses the border color.
# The smaller rectangle covers its center with the inner fill color.
# This creates the appearance of an outline.
static func draw_rounded_rect_stroke(canvas: CanvasItem, rect: Rect2, color: Color, width: float, radius: float, _join_round: bool, inner_fill_color: Color) -> void:

	# Keep the corner radius within valid dimensions.
	var r = clampf(radius, 0, minf(rect.size.x, rect.size.y) * 0.5)

	# Do not draw a border if its thickness is zero or negative.
	if width <= 0:
		return

	# Calculate the smaller rectangle inside the border.
	# Moving its position inward and reducing its size
	# leaves space around it for the border.
	var inner = Rect2(rect.position + Vector2(width, width), rect.size - Vector2(width * 2, width * 2))

	# Stop if the inner rectangle has no drawable area.
	if inner.size.x <= 0 or inner.size.y <= 0:
		return

	# Reduce the inner corner radius to match the smaller rectangle.
	var inner_r = maxf(0, r - width)

	# First draw the entire outer rectangle in the border color.
	draw_rounded_rect_filled(canvas, rect, color, r)

	# Then draw the smaller rectangle over its center.
	draw_rounded_rect_filled(canvas, inner, inner_fill_color, inner_r)


# =========================
# DRAW APPROXIMATE SHADOW
# =========================

# Creates a shadow effect using multiple overlapping polygons.
#
# Each pass draws another partially transparent shape.
# This approximates a soft shadow without using a blur shader.
static func draw_shadow_approximate(canvas: CanvasItem, rect: Rect2, radius: float, shadow_color: Color, offset: Vector2, passes: int) -> void:

	# Count backward from the number of passes down to 1.
	for i in range(passes, 0, -1):

		# Calculate transparency for the current shadow layer.
		var alpha = shadow_color.a * (float(i) / float(passes)) * 0.5

		# Create a color with the calculated transparency.
		var c = Color(shadow_color.r, shadow_color.g, shadow_color.b, alpha)

		# Copy the rectangle so its position can be adjusted.
		var r2 = rect

		# Move the current shadow layer toward the specified offset.
		r2.position += offset * (float(passes - i + 1) / float(passes))

		# Generate the rounded shape for this shadow layer.
		var pts = make_rounded_rect_polygon(r2, radius + i * 2)

		# Draw the current semi-transparent layer.
		canvas.draw_colored_polygon(pts, c)

	# Draw a fully transparent polygon using the original rectangle.
	canvas.draw_colored_polygon(make_rounded_rect_polygon(rect, radius), Color(0, 0, 0, 0))


# =========================
# DRAW GRADIENT OVERLAY
# =========================

# Draws a color gradient over a rectangle.
#
# The gradient can be horizontal, vertical, or diagonal.
# The style Resource supplies the colors and settings.
static func draw_gradient_overlay(canvas: CanvasItem, rect: Rect2, _radius: float, style: GodotxHealthBarStyle) -> void:

	# Skip drawing if the gradient is disabled or has no intensity.
	if not style.gradient_enabled or style.gradient_intensity <= 0:
		return

	# Divide the gradient into 24 separate drawing sections.
	var steps = 24

	# match works similarly to a switch statement.
	# It selects a section of code based on the gradient direction.
	match style.gradient_direction:

		# Horizontal gradient changes color from left to right.
		GodotxHealthBarEnums.GradientDirection.HORIZONTAL:

			# Draw 24 vertical strips across the rectangle.
			for i in range(steps):

				# Calculate the starting and ending fractions.
				var t0 = float(i) / float(steps)
				var t1 = float(i + 1) / float(steps)

				# Convert the fractions into X coordinates.
				var x0 = rect.position.x + rect.size.x * t0
				var x1 = rect.position.x + rect.size.x * t1

				# lerp() blends between two colors.
				# The midpoint of the current strip determines its color.
				var c = style.gradient_start_color.lerp(style.gradient_end_color, (t0 + t1) * 0.5)

				# Adjust transparency using the gradient intensity.
				c.a *= style.gradient_intensity

				# Draw the current vertical strip.
				canvas.draw_rect(Rect2(x0, rect.position.y, x1 - x0, rect.size.y), c)

		# Vertical gradient changes color from top to bottom.
		GodotxHealthBarEnums.GradientDirection.VERTICAL:

			# Draw 24 horizontal strips.
			for i in range(steps):

				# Calculate the current section's fractions.
				var t0 = float(i) / float(steps)
				var t1 = float(i + 1) / float(steps)

				# Convert the fractions into Y coordinates.
				var y0 = rect.position.y + rect.size.y * t0
				var y1 = rect.position.y + rect.size.y * t1

				# Calculate the blended color for this strip.
				var c = style.gradient_start_color.lerp(style.gradient_end_color, (t0 + t1) * 0.5)

				# Apply the gradient's transparency intensity.
				c.a *= style.gradient_intensity

				# Draw the current horizontal strip.
				canvas.draw_rect(Rect2(rect.position.x, y0, rect.size.x, y1 - y0), c)

		# These two enum values share the same drawing section.
		GodotxHealthBarEnums.GradientDirection.DIAGONAL_TOP_LEFT, GodotxHealthBarEnums.GradientDirection.DIAGONAL_BOTTOM_LEFT:

			# Choose a positive or negative direction depending on the enum.
			var sy: float = 1.0 if style.gradient_direction == GodotxHealthBarEnums.GradientDirection.DIAGONAL_TOP_LEFT else -1.0

			# Generate each section of the gradient.
			for i in range(steps):

				# Calculate the midpoint fraction of this section.
				var t = (float(i) + 0.5) / float(steps)

				# Blend the start and end colors.
				var c = style.gradient_start_color.lerp(style.gradient_end_color, t)

				# Apply the configured gradient intensity.
				c.a *= style.gradient_intensity

				# Calculate the horizontal boundaries.
				var x0 = rect.position.x + rect.size.x * float(i) / float(steps)
				var x1 = rect.position.x + rect.size.x * float(i + 1) / float(steps)

				# Calculate vertical positions using the selected direction.
				var y0 = rect.position.y + rect.size.y * (1.0 - sy) * 0.5 + sy * rect.size.y * float(i) / float(steps)
				var y1 = rect.position.y + rect.size.y * (1.0 - sy) * 0.5 + sy * rect.size.y * float(i + 1) / float(steps)

				# Create a four-point polygon covering a vertical strip.
				var pts = PackedVector2Array([
					Vector2(x0, rect.position.y), Vector2(x1, rect.position.y),
					Vector2(x1, rect.position.y + rect.size.y), Vector2(x0, rect.position.y + rect.size.y)
				])

				# Draw the strip using the calculated color.
				canvas.draw_colored_polygon(pts, c)

		# Do nothing if the gradient direction does not match.
		_:
			pass


# =========================
# DRAW FITTED TEXTURE
# =========================

# Draws an image inside a rectangle.
#
# Different fit modes determine how the image is resized.
# FIT keeps the entire image visible.
# FILL scales the image to cover the destination dimensions.
# STRETCH uses the destination rectangle's dimensions directly.
static func draw_texture_fitted(canvas: CanvasItem, rect: Rect2, texture: Texture2D, tint: Color, fit_mode: int) -> void:

	# Stop if no texture was provided.
	if not texture:
		return

	# Read the original image's width and height.
	var ts = texture.get_size()

	# Stop if the image has invalid dimensions.
	if ts.x <= 0 or ts.y <= 0:
		return

	# Define the source rectangle covering the entire texture.
	var src_rect = Rect2(Vector2.ZERO, ts)

	# Initially use the requested destination rectangle.
	var dst_rect = rect

	# Select how the image should fit into its destination.
	match fit_mode:

		# FIT preserves proportions and keeps the entire image
		# within the destination rectangle.
		GodotxHealthBarEnums.IconFitMode.FIT:

			# Choose the smaller scaling factor.
			var scale = minf(rect.size.x / ts.x, rect.size.y / ts.y)

			# Calculate the resized image dimensions.
			var sz = ts * scale

			# Center the resized image inside the destination.
			dst_rect = Rect2(rect.position + (rect.size - sz) * 0.5, sz)

		# FILL preserves proportions while scaling the image
		# large enough to cover the destination dimensions.
		GodotxHealthBarEnums.IconFitMode.FILL:

			# Choose the larger scaling factor.
			var scale = maxf(rect.size.x / ts.x, rect.size.y / ts.y)

			# Calculate the resized image dimensions.
			var sz = ts * scale

			# Center the resized image relative to the destination.
			dst_rect = Rect2(rect.position + (rect.size - sz) * 0.5, sz)

		# STRETCH keeps the original destination rectangle.
		# The image can change proportions to fit it.
		GodotxHealthBarEnums.IconFitMode.STRETCH:
			pass

	# Draw the texture using its source and destination rectangles.
	# tint applies an optional color modification.
	canvas.draw_texture_rect_region(texture, dst_rect, src_rect, tint)
