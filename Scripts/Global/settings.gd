extends Node

# COLOR_3 = Neutral-color | COLOR_SPECIAL = Special note color -> BOTH CAN'T CHANGE
enum NoteColor { COLOR_1, COLOR_2, COLOR_3, COLOR_SPECIAL }
enum Lane { LANE_1, LANE_2, LANE_3, LANE_4, LANE_SPECIAL }




# ALL OF THESE SETTINGS VARIABLES ARE ASSIGNED TO DEFAULT VALUES, HOWEVER
# THE load_settings() FUNCTION WILL OVERWRITE ALL DEFAULT VALUES IF APPLICABLE

# Volume Settings (1.0 = 100%)
var masterVolume = 1.0
var musicVolume = 1.0
var effectVolume = 1.0


# Gameplay Settings
# Scroll speed = multiplier | Judgement/Display Offset = milliseconds
var scrollSpeed = 1.0
var judgementOffset = 0.0
var displayOffset = 0.0
var showJudgementFeedback = false


# Cosmetic/Input Settings
var laneKeyBindings = { 
	Lane.LANE_1: KEY_D, 
	Lane.LANE_2: KEY_F, 
	Lane.LANE_3: KEY_J, 
	Lane.LANE_4: KEY_K,
	Lane.LANE_SPECIAL: KEY_SPACE
}
var colorKeyBindings = { NoteColor.COLOR_1: KEY_S, NoteColor.COLOR_2: KEY_L }
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
	
	config.set_value("volume", "masterVolume", masterVolume)
	config.set_value("volume", "musicVolume", musicVolume)
	config.set_value("volume", "effectVolume", effectVolume)
	
	config.set_value("gameplay", "scrollSpeed", scrollSpeed)
	config.set_value("gameplay", "judgementOffset", judgementOffset)
	config.set_value("gameplay", "displayOffset", displayOffset)
	config.set_value("gameplay", "showJudgementFeedback", showJudgementFeedback)
	
	config.set_value("input", "laneKeyBindings", laneKeyBindings)
	config.set_value("input", "colorKeyBindings", colorKeyBindings)
	config.set_value("appearance", "noteColors", noteColors)
	config.set_value("appearance", "laneTransparency", laneTransparency)
	
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config = ConfigFile.new()
	# Check if this is first time launching, OK = built-in constant meaning no error
	if config.load("user://settings.cfg") != OK: 
		return
	
	masterVolume = config.get_value("volume", "masterVolume", 1.0)
	musicVolume = config.get_value("volume", "musicVolume", 1.0)
	effectVolume = config.get_value("volume", "effectVolume", 1.0)
	
	scrollSpeed = config.get_value("gameplay", "scrollSpeed", 1.0)
	judgementOffset = config.get_value("gameplay", "judgementOffset", 0.0)
	displayOffset = config.get_value("gameplay", "displayOffset", 0.0)
	showJudgementFeedback = config.get_value("gameplay", "showJudgementFeedback", false)
	
	laneKeyBindings = config.get_value("input", "laneKeyBindings", DEFAULT_LANE_KEY_BINDINGS)
	colorKeyBindings = config.get_value("input", "colorKeyBindings", DEFAULT_COLOR_KEY_BINDINGS) 
	noteColors = config.get_value("appearance", "noteColors", DEFAULT_NOTE_COLORS) 
	laneTransparency = config.get_value("appearance", "laneTransparency", 1.0)



# "Reset to Default Values" functions
func reset_volume_to_default() -> void:
	masterVolume = DEFAULT_MASTER_VOLUME
	musicVolume = DEFAULT_MUSIC_VOLUME
	effectVolume = DEFAULT_EFFECT_VOLUME

func reset_gameplay_to_default() -> void:
	scrollSpeed = DEFAULT_SCROLL_SPEED
	judgementOffset = DEFAULT_JUDGEMENT_OFFSET
	displayOffset = DEFAULT_DISPLAY_OFFSET
	showJudgementFeedback = DEFAULT_SHOW_JUDGEMENT_FEEDBACK

func reset_keybinds_to_default() -> void:
	laneKeyBindings = DEFAULT_LANE_KEY_BINDINGS
	colorKeyBindings = DEFAULT_COLOR_KEY_BINDINGS

func reset_colors_to_default() -> void:
	noteColors = DEFAULT_NOTE_COLORS
