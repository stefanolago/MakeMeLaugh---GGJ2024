extends CanvasLayer


@export var start_game_scene: PackedScene


@onready var options_menu: Control = $Control/OptionsMenu
@onready var credits_screen: Control = $Control/Credits
@onready var title: Label = $Tile

func _on_options_button_pressed() -> void:
	($Confirm_sfx as AudioStreamPlayer).play()
	activate_options_menu(true)
	title.visible = false

func _on_options_menu_close_option_menu() -> void:
	activate_options_menu(false)
	title.visible = true

func activate_options_menu(activated: bool) -> void:
	options_menu.visible = activated
	for button: Button in $Control/Buttons.get_children():
		button.disabled = activated


func _on_quit_button_pressed() -> void:
	($Confirm_sfx as AudioStreamPlayer).play()
	get_tree().quit()

func _on_credits_button_pressed() -> void:
	($Confirm_sfx as AudioStreamPlayer).play()
	credits_screen.visible = true
	title.visible = false


func _on_play_button_pressed() -> void:
	($Confirm_sfx as AudioStreamPlayer).play()
	TransitionLayer.change_scene(start_game_scene)
	title.visible = false


func _on_credits_credits_back_button() -> void:
	title.visible = true
