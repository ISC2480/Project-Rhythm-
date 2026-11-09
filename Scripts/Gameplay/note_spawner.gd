class_name NoteSpawner
extends Node3D

const TAP_NOTE_SCENE = preload ("res://Scenes/tap_note.tscn")
@export var note_speed: float = 3.0
@export var stationary_tapnotes: Node3D

# Using @onready to include the other child nodes in the scene
@onready var spawn_markers= {
	Settings.Lane.LANE_1: $Spawn1,
	Settings.Lane.LANE_2: $Spawn2,
	Settings.Lane.LANE_3: $Spawn3,
	Settings.Lane.LANE_4: $Spawn4 
}
@onready var notes_container: Node3D = $"../Notes"


func spawn_note(note_data: NoteData) -> Note:
	var marker: Marker3D = spawn_markers.get(note_data.lane)
	
	var note: Note = TAP_NOTE_SCENE.instantiate() as Note
	if note == null: return null
	
	# Copying next note_data from a song chart to current spawning note
	note.hit_time = note_data.hit_time
	note.lane = note_data.lane
	note.note_color = note_data.note_color
	
	notes_container
	
	return note

#func spawn_note(lane: int) -> void:
	#if lane < 0 or lane >= 4:
		#return
#
	#if stationary_tapnotes == null:
		#push_warning("Stationary TapNotes not assigned!")
		#return
#
	## Create a new TapNote scene
	#var note = TAP_NOTE_SCENE.instantiate()
#
	## Configure it as a moving note
	#note.lane = lane
	#note.note_speed = note_speed
	#note.is_moving = true
#
	## Add the note to the scene
	#add_child(note)
#
	## Start at the same origin as the stationary notes
	#note.global_transform = stationary_tapnotes.global_transform


#func _on_spawn_timer_timeout() -> void:
	#var random_lane = randi_range(0, 3)
	#spawn_note(random_lane)
