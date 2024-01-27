extends Control

signal credits_back_button()

@export var final_credits:bool = false
var main_menu: String = "res://scenes/_start/start_menu.tscn"


func _ready() -> void:
	($doggo_1 as AnimatedSprite2D).play()
	($doggo_2 as AnimatedSprite2D).play()


func _on_back_button_pressed() -> void:
	visible = false
	($back_button as AudioStreamPlayer).play()
	if final_credits:
		GameStats.reset()
		TransitionLayer.change_scene_to_file(main_menu)
	else:
		credits_back_button.emit()


func _on_back_button_mouse_entered():
	($hover_sfx as AudioStreamPlayer).play()
