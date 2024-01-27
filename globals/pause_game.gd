extends Node

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
				print (is_pointer_vis)
				get_tree().paused = true
				self.visible = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			false:
				get_tree().paused = false
				self.visible = false
				if is_pointer_vis == false:
					Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		game_is_pause = !game_is_pause


