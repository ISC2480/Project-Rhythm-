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
	# signed_time_difference is for showJudgementFeedback
	var signed_time_difference = (input_time - note_time - offset) * 1000.0 
	var time_difference = abs(signed_time_difference)
	
	
	# return judgement label based on how accurate the user timed the note
	if time_difference <= PERFECT_WINDOW: 
		print(Judgement.PERFECT)
		return Judgement.PERFECT
	elif time_difference <= GREAT_WINDOW:
		print(Judgement.GREAT) 
		return Judgement.GREAT
	elif time_difference <= GOOD_WINDOW: 
		print(Judgement.GOOD) 
		return Judgement.GOOD
	
	# If the note isn't hit within abs(150 ms), they missed the note
	else:
		print(Judgement.MISS)
		return Judgement.MISS
