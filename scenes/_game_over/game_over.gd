extends Control

var main_menu: String = "res://scenes/_start/start_menu.tscn"
var current_volume: float 
@onready var game_over_player: AudioStreamPlayer = $game_over_player

func _on_back_button_pressed() -> void:
	game_over_player.stop()
	GameStats.reset()
	TransitionLayer.change_scene_to_file(main_menu)


func _on_back_button_mouse_entered() -> void:
	($hover as AudioStreamPlayer).play()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fade_music_in(game_over_player, 2)


func fade_music_in(stream_player:AudioStreamPlayer, speed:float) -> void:
	var music_tween: Tween = get_tree().create_tween()
	current_volume = stream_player.volume_db
	stream_player.volume_db = -60
	music_tween.tween_callback(stream_player.play)
	music_tween.tween_property(stream_player, "volume_db", current_volume, speed)


func fade_music_out(stream_player:AudioStreamPlayer, speed:float) -> void:
	var music_tween: Tween = get_tree().create_tween()
	music_tween.tween_property(stream_player, "volume_db", -40, speed)
	music_tween.tween_callback(stream_player.stop)
