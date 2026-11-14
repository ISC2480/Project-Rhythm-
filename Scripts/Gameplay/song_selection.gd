
extends Control

# =========================
# SONG SELECTION
# =========================

# References to the four existing song boxes.
@onready var song_boxes = [
	$SongList/SongBox,
	$SongList/SongBox2,
	$SongList/SongBox3,
	$SongList/SongBox4
]

# The first song is selected when the menu opens.
var selected_song: int = 0

# Colors for selected and unselected songs.
var normal_color: Color = Color("#FFFFFF")
var selected_color: Color = Color("#FFFF00")


# =========================
# INITIAL SETUP
# =========================

func _ready() -> void:
	# Highlight the first song.
	update_selection()


# =========================
# KEYBOARD INPUT
# =========================

func _unhandled_key_input(event: InputEvent) -> void:
	# Only respond when a key is pressed.
	# Ignore repeated signals from holding a key.
	if not event.pressed or event.echo:
		return

	# Move down to the next song.
	if event.keycode == KEY_DOWN:
		selected_song = (selected_song + 1) % song_boxes.size()
		update_selection()

	# Move up to the previous song.
	elif event.keycode == KEY_UP:
		selected_song = (selected_song - 1 + song_boxes.size()) % song_boxes.size()
		update_selection()

	# Enter starts the selected song.
	elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
		start_song()


# =========================
# VISUAL SELECTION
# =========================

func update_selection() -> void:
	# Go through all four song boxes.
	for i in range(song_boxes.size()):
		# Highlight the selected box.
		if i == selected_song:
			song_boxes[i].modulate = selected_color
		else:
			# Restore the other boxes.
			song_boxes[i].modulate = normal_color


# =========================
# START GAMEPLAY
# =========================

func start_song() -> void:
	# Print which song was selected for testing.
	print("Starting Song ", selected_song + 1)

	# Load the existing gameplay scene.
	get_tree().change_scene_to_file("res://Scenes/gameplay.tscn")
