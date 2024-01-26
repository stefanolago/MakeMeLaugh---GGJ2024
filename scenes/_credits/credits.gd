extends Control

signal credits_back_button()

func _on_back_button_pressed() -> void:
	visible = false
	credits_back_button.emit()
