extends Node

var game_is_pause:bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_is_pause = !game_is_pause
