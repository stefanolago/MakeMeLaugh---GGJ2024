extends Control

var bossfight:PackedScene = preload("res://scenes/game/bossfight/bossfight.tscn") 
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)
	anim_player.play("intro_cinematic")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	


func DialogicSignal(argument:String) -> void:
	if argument == "bossfight":
		print ("loading bossfight")
		TransitionLayer.change_scene(bossfight)
	if argument == "progress_animation":
		Dialogic.paused = true
		anim_player.active = true
		print("continue playing")


func continue_dialogic() -> void:
	anim_player.active = false
	Dialogic.paused = false


func start_dialogic() -> void:
	anim_player.active = false
	print("pausing")
	Dialogic.start("intro")


func load_next_level() -> void:
	Dialogic.paused = false
	TransitionLayer.change_scene(bossfight)
