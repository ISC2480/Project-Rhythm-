class_name JudgementSystem
extends Node

# Offset-related values are formatted in milliseconds
# Song duration, note times, and input times -> formatted in seconds
# Keep in mind to convert accordingly when calculating both of them together:
	# 1 second = milliseconds / 1000

# float values represent milliseconds 
enum Judgement { PERFECT, GREAT, GOOD, MISS }
const PERFECT_WINDOW = 50.0
const GREAT_WINDOW = 100.0
const GOOD_WINDOW = 150.0


func calculate_note_judgement(note_time: float, input_time: float) -> Judgement:
	# converting to seconds
	var offset = Settings.judgementOffset / 1000.0      
	var time_difference = abs(input_time - note_time - offset) * 1000.0
	
	# return judgement label based on how accurate the user timed the note
	if time_difference <= PERFECT_WINDOW: return Judgement.PERFECT
	elif time_difference <= GREAT_WINDOW: return Judgement.GREAT
	elif time_difference <= GOOD_WINDOW: return Judgement.GOOD
	
	# If the note isn't hit within abs(150 ms), they missed the note
	return Judgement.MISS
