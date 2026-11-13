
extends Node3D

# =========================
# NODE REFERENCES
# =========================

@onready var note_manager: NoteManager = $NoteManager
@onready var input_handler: InputHandler = $InputHandler
@onready var judgement_system: JudgementSystem = $JudgementSystem

# Reference to our HUD scene.
@onready var hud = $HUD

var song_time: float = 0.0


# =========================
# INITIAL SETUP
# =========================

func _ready() -> void:
	input_handler.lane_pressed.connect(_on_lane_pressed)
	note_manager.note_missed.connect(_on_note_missed)


# =========================
# GAMEPLAY TIMING
# =========================

func _process(delta: float) -> void:
	song_time += delta

	# TEMPORARY: Generate endless test notes.
	# Comment out this line when testing is finished.
	note_manager.generate_endless_test_notes(song_time)

	# Spawn, move, and judge notes normally.
	note_manager.update_notes(song_time)
	
	
# =========================
# PLAYER INPUT AND JUDGMENT
# =========================

func _on_lane_pressed(lane: int) -> void:

	var note = note_manager.find_closest_note(lane, song_time)

	if note == null:
		return

	# Evaluate input against the scheduled hit time.
	var result = judgement_system.calculate_note_judgement(
		note.hit_time, song_time
	)

	if result == JudgementSystem.Judgement.MISS:
		return

	# NEW: Display the judgment on our HUD.
	hud.show_judgment(
		JudgementSystem.Judgement.keys()[result]
	)
	# Update health based on the judgment.
	hud.apply_judgment_health(
		JudgementSystem.Judgement.keys()[result]
	)

	print("Lane: ", lane,
		  " | Judgement: ", JudgementSystem.Judgement.keys()[result],
		  " | Time Difference: ",
		  snappedf(judgement_system.calculate_signed_time_difference(note.hit_time, song_time), 0.01), "ms ",
		  " | Hit Time: ", snappedf(note.hit_time, 0.001),
		  " | User Hit Time: ", snappedf(song_time, 0.001)
	)

	# Remove the note if it was hit.
	note_manager.remove_note(note)


# =========================
# MISSED NOTES
# =========================


func _on_note_missed(note: Note) -> void:
	# Print the missed note for debugging.
	print("MISS | Lane: ", note.lane)

	# Display MISS on the HUD.
	hud.show_judgment("MISS")

	# Deduct 10 health when a note is missed.
	hud.apply_judgment_health("MISS")
