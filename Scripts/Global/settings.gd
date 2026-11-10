extends Node

# COLOR_3 = Neutral-color | COLOR_SPECIAL = Special note color -> BOTH CAN'T CHANGE
enum NoteColor { COLOR_1, COLOR_2, COLOR_3, COLOR_SPECIAL }
enum Lane { LANE_1, LANE_2, LANE_3, LANE_4, LANE_SPECIAL }


# ALL OF THESE SETTINGS VARIABLES ARE ASSIGNED TO DEFAULT VALUES, HOWEVER
# THE load_settings() FUNCTION WILL OVERWRITE ALL DEFAULT VALUES IF THE USER
# HAS CUSTOM VALUES IN settings.cfg

# Volume Settings (1.0 = 100%)
var master_volume = DEFAULT_MASTER_VOLUME
var music_volume = DEFAULT_MUSIC_VOLUME
var effect_volume = DEFAULT_EFFECT_VOLUME


# Gameplay Settings
# Scroll speed = multiplier | Judgement/Display Offset = milliseconds
var scroll_speed = DEFAULT_SCROLL_SPEED
var judgement_offset = DEFAULT_JUDGEMENT_OFFSET
var display_offset = DEFAULT_DISPLAY_OFFSET
var show_judgement_feedback = DEFAULT_SHOW_JUDGEMENT_FEEDBACK


# Cosmetic/Input Settings
var lane_key_bindings = { 
	Lane.LANE_1: KEY_D, 
	Lane.LANE_2: KEY_F, 
	Lane.LANE_3: KEY_J, 
	Lane.LANE_4: KEY_K,
	Lane.LANE_SPECIAL: KEY_SPACE
}
var color_key_bindings = { NoteColor.COLOR_1: KEY_S, NoteColor.COLOR_2: KEY_L }
# COLOR_3 = Neutral-color | COLOR_SPECIAL = Special note color -> BOTH CAN'T CHANGE
var noteColors = {
	NoteColor.COLOR_1: Color(0.9, 0.3, 0.5),
	NoteColor.COLOR_2: Color(0.2, 0.65, 0.75),
	NoteColor.COLOR_3: Color(0.3, 0.3, 0.3),
	NoteColor.COLOR_SPECIAL: Color(1, 0.8, 0.2)
}
var laneTransparency = 0.0



# DEFAULT/DUPLICATE SETTING VARIABLES IN CASE OF RESETTING TO DEFAULT FUNCTIONS
const DEFAULT_MASTER_VOLUME = 1.0
const DEFAULT_MUSIC_VOLUME = 1.0
const DEFAULT_EFFECT_VOLUME = 1.0

const DEFAULT_SCROLL_SPEED = 1.0
const DEFAULT_JUDGEMENT_OFFSET = 0.0
const DEFAULT_DISPLAY_OFFSET = 0.0
const DEFAULT_SHOW_JUDGEMENT_FEEDBACK = false

const DEFAULT_LANE_KEY_BINDINGS = {
	Lane.LANE_1: KEY_D,
	Lane.LANE_2: KEY_F,
	Lane.LANE_3: KEY_J,
	Lane.LANE_4: KEY_K,
	Lane.LANE_SPECIAL: KEY_SPACE
}
const DEFAULT_COLOR_KEY_BINDINGS = {
	NoteColor.COLOR_1: KEY_S,
	NoteColor.COLOR_2: KEY_L
}
const DEFAULT_NOTE_COLORS = {
	NoteColor.COLOR_1: Color(0.9, 0.3, 0.5),
	NoteColor.COLOR_2: Color(0.2, 0.65, 0.75),
	NoteColor.COLOR_3: Color(0.3, 0.3, 0.3),
	NoteColor.COLOR_SPECIAL: Color(1, 0.8, 0.2)
}
const DEFAULT_LANE_TRANSPARENCY = 0.0



# ConfigFile METHODS INFORMATION
	# set_value(section: String, key: String, value: Variant): void
	# section: A group/category that the key will live under
	# key: name of the value within the specified section
	# value: the data that you will store in the key
	#
	# get_value(section: String, key: String, default: Variant = null) const: Variant
	# section and key identifies which values to read
	# default: what to return if the section/key doesn't exist in the .cfg file

func save_settings() -> void:
	var config = ConfigFile.new()
	
	config.set_value("volume", "masterVolume", master_volume)
	config.set_value("volume", "musicVolume", music_volume)
	config.set_value("volume", "effectVolume", effect_volume)
	
	config.set_value("gameplay", "scrollSpeed", scroll_speed)
	config.set_value("gameplay", "judgementOffset", judgement_offset)
	config.set_value("gameplay", "displayOffset", display_offset)
	config.set_value("gameplay", "showJudgementFeedback", show_judgement_feedback)
	
	config.set_value("input", "laneKeyBindings", lane_key_bindings)
	config.set_value("input", "colorKeyBindings", color_key_bindings)
	config.set_value("appearance", "noteColors", noteColors)
	config.set_value("appearance", "laneTransparency", laneTransparency)
	
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config = ConfigFile.new()
	# Check if this is first time launching, OK = built-in constant meaning no error
	if config.load("user://settings.cfg") != OK: 
		return
	
	master_volume = config.get_value("volume", "masterVolume", DEFAULT_MASTER_VOLUME)
	music_volume = config.get_value("volume", "musicVolume", DEFAULT_MUSIC_VOLUME)
	effect_volume = config.get_value("volume", "effectVolume", DEFAULT_EFFECT_VOLUME)
	
	scroll_speed = config.get_value("gameplay", "scrollSpeed", DEFAULT_SCROLL_SPEED)
	judgement_offset = config.get_value("gameplay", "judgementOffset", DEFAULT_JUDGEMENT_OFFSET)
	display_offset = config.get_value("gameplay", "displayOffset", DEFAULT_DISPLAY_OFFSET)
	show_judgement_feedback = config.get_value("gameplay", "showJudgementFeedback", DEFAULT_SHOW_JUDGEMENT_FEEDBACK)
	
	lane_key_bindings = config.get_value("input", "laneKeyBindings", DEFAULT_LANE_KEY_BINDINGS)
	color_key_bindings = config.get_value("input", "colorKeyBindings", DEFAULT_COLOR_KEY_BINDINGS) 
	noteColors = config.get_value("appearance", "noteColors", DEFAULT_NOTE_COLORS) 
	laneTransparency = config.get_value("appearance", "laneTransparency", DEFAULT_LANE_TRANSPARENCY)



# "Reset to Default Values" functions
func reset_volume_to_default() -> void:
	master_volume = DEFAULT_MASTER_VOLUME
	music_volume = DEFAULT_MUSIC_VOLUME
	effect_volume = DEFAULT_EFFECT_VOLUME

func reset_gameplay_to_default() -> void:
	scroll_speed = DEFAULT_SCROLL_SPEED
	judgement_offset = DEFAULT_JUDGEMENT_OFFSET
	display_offset = DEFAULT_DISPLAY_OFFSET
	show_judgement_feedback = DEFAULT_SHOW_JUDGEMENT_FEEDBACK

# Dictionaries in GDScript have the values as references
# Use .duplicate() to assign by copy rather than by reference
func reset_keybinds_to_default() -> void:
	lane_key_bindings = DEFAULT_LANE_KEY_BINDINGS.duplicate()
	color_key_bindings = DEFAULT_COLOR_KEY_BINDINGS.duplicate()

func reset_appearance_to_default() -> void:
	noteColors = DEFAULT_NOTE_COLORS.duplicate()
	laneTransparency = DEFAULT_LANE_TRANSPARENCY
