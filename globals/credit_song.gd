extends Control

func start_song() -> void:
	($AudioStreamPlayer as AudioStreamPlayer).play()

func stop_song() -> void:
	($AudioStreamPlayer as AudioStreamPlayer).stop()
