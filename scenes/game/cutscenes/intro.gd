extends Control

var bossfight:PackedScene = preload("res://scenes/game/bossfight/bossfight.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready():
	Dialogic.signal_event.connect(DialogicSignal)
	Dialogic.start("intro")

func DialogicSignal(argument:String):
	if argument == "bossfight":
		print ("loading bossfight")
		TransitionLayer.change_scene(bossfight)
