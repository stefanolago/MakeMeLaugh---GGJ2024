extends Node

var game_is_pause:bool = false:
	set(value):
		game_is_pause = value
		match game_is_pause:
			true:
				print ("pausing")
				get_tree().paused = true
			false:
				print ("un pausing")
				get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_is_pause = !game_is_pause


