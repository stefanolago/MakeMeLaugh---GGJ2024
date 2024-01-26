extends Control

var credits:PackedScene = preload("res://scenes/_credits/credits.tscn") 
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)
	anim_player.play("ending_cinematic")
	#Dialogic.start("ending")


func DialogicSignal(argument:String) -> void:
	if argument == "credits":
		TransitionLayer.change_scene(credits)
	if argument == "progress_animation":
		Dialogic.paused = true
		anim_player.active = true
		print("continue playing")


