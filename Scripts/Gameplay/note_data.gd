extends Resource
class_name NoteData

# Bar and Bar2 spans all four lanes and uses Space.
enum NoteType { TAP, HOLD, BAR, BAR_TWO,} 

@export var hit_time: float
@export var hold_duration: float
@export var note_type: NoteType
@export var note_color: Settings.NoteColor
@export var lane: Settings.Lane
