extends Node3D

@onready var note_manager: NoteManager = $NoteManager
@onready var input_handler: InputHandler = $InputHandler
@onready var judgement_system: JudgementSystem = $JudgementSystem

var song_time: float = 0.0

func _ready() -> void:
	input_handler.lane_pressed.connect(_on_lane_pressed)
	note_manager.note_missed.connect(_on_note_missed)


func _process(delta: float) -> void:
	song_time += delta
	note_manager.update_notes(song_time)


func _on_lane_pressed(lane: int) -> void:
	var note = note_manager.find_closest_note(lane, song_time)

	if note == null: return

	# Evaluating input against scheduled hit time
	var result = judgement_system.calculate_note_judgement(note.hit_time, song_time)

	if result == JudgementSystem.Judgement.MISS: return

	print("Lane: ", lane, 
		  " | Judgement: ", JudgementSystem.Judgement.keys()[result],
		  " | Time Difference: ", 
		  snappedf(judgement_system.calculate_signed_time_difference(note.hit_time, song_time), 0.01), "ms ",
		  " | Hit Time: ", snappedf(note.hit_time, 0.001),
		  " | User Hit Time: ", snappedf(song_time, 0.001)
	)
	# Remove the note if it was hit
	note_manager.remove_note(note)


func _on_note_missed(note: Note) -> void:
	print("MISS | Lane: ", note.lane)
