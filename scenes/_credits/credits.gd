extends Control

signal credits_back_button()

@export var final_credits:bool = false
var main_menu: String = "res://scenes/_start/start_menu.tscn"

func _on_back_button_pressed() -> void:
	visible = false
	if final_credits:
		TransitionLayer.change_scene_to_file(main_menu)
	else:
		credits_back_button.emit()
