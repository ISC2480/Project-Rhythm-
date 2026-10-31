class_name JudgementSystem
extends Node

# Offset-related values are formatted in milliseconds
# Song duration, note times, and input times -> formatted in seconds
# Keep in mind to convert accordingly when calculating both of them together:
	# 1 second = milliseconds / 1000

enum Judgement { PERFECT, GREAT, GOOD, MISS }
# float values represent milliseconds 
const PERFECT_WINDOW = 50.0
const GREAT_WINDOW = 100.0
const GOOD_WINDOW = 150.0

func calculate_note_judgement(note_time: float, input_time: float) -> Judgement:
	# converting to seconds
	var offset = Settings.judgementOffset / 1000.0      
	var time_difference = abs(input_time - note_time - offset) * 1000.0
	
	
	
	# If the note isn't hit within abs(150 ms), they missed the note
	return Judgement.MISS

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
