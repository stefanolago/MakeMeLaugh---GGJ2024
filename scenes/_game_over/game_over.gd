extends Control

var main_menu: String = "res://scenes/_start/start_menu.tscn"


func _on_back_button_pressed() -> void:
	GameStats.reset()
	TransitionLayer.change_scene_to_file(main_menu)


func _on_back_button_mouse_entered():
	($hover as AudioStreamPlayer).play()
