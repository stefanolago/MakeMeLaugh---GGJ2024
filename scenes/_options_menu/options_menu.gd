extends Control

signal close_option_menu

func _on_back_button_pressed() -> void:
	close_option_menu.emit()
	($back_button as AudioStreamPlayer).play()

