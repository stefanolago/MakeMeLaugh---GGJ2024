extends Control

var is_pointer_vis: bool

var game_is_pause:bool = false:
	set(value):
		game_is_pause = value

		match game_is_pause:
			true:
				if Input.mouse_mode == Input.MouseMode.MOUSE_MODE_HIDDEN:
					is_pointer_vis = false
				else:
					is_pointer_vis = true
				get_tree().paused = true
				visible = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			false:
				get_tree().paused = false
				visible = false
				if is_pointer_vis == false:
					Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().current_scene.name != "StartMenu":
			game_is_pause = !game_is_pause


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_quit_button_mouse_entered() -> void:
	($hover as AudioStreamPlayer).play()
