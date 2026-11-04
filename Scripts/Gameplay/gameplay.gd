extends Node
@onready var note_manager: NoteManager = $NoteManager

var selected_chart: SongChart
var current_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	note_manager.load_chart(selected_chart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time += delta
	# note_manager.update_notes(current_time) 
