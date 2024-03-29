extends Control

var credits:PackedScene = preload("res://scenes/_credits/credits.tscn") 
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)
	anim_player.play("ending_cinematic")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func DialogicSignal(argument:String) -> void:
	if argument == "credits":
		TransitionLayer.change_scene(credits)
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
	Dialogic.start("ending")


func load_next_level() -> void:
	Dialogic.paused = false
	TransitionLayer.change_scene(credits)


func start_credits_song() -> void:
	CreditSong.start_song()
