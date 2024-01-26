extends Control

var credits:PackedScene = preload("res://scenes/_credits/credits.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(DialogicSignal)
	Dialogic.start("ending")


func DialogicSignal(argument:String):
	if argument == "credits":
		TransitionLayer.change_scene(credits)
