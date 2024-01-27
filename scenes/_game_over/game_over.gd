extends Control

var main_menu: String = "res://scenes/_start/start_menu.tscn"


func _on_back_button_pressed() -> void:
	TransitionLayer.change_scene_to_file(main_menu)

