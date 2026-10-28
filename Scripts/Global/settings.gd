extends Node

enum NoteColor
{
	COLOR_1, 
	COLOR_2,
	COLOR_3, # Neutral-colored note; Can't change
	COLOR_4, # Special note's color; Can't change
}

# Volume Settings
var masterVolume = 1.0
var musicVolume = 1.0
var effectVolume = 1.0

# Gameplay/Timing Settings
# Scroll speed = multiplier | Judgement/Display Offset = milliseconds
var scrollSpeed = 1.0
var judgementOffset = 0.0
var displayOffset = 0.0
var showJudgementFeedback: bool = false

# Cosmetic/Input Settings
var keyBindings
var noteColors

func save_settings() -> void:
	var config = ConfigFile.new()
	
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config = ConfigFile.new()
