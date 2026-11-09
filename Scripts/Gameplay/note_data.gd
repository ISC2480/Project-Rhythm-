extends Resource
class_name NoteData

enum NoteType { TAP, HOLD }

@export var hit_time: float
@export var hold_duration: float
@export var note_type: NoteType
@export var note_color: Settings.NoteColor
@export var lane: Settings.Lane
