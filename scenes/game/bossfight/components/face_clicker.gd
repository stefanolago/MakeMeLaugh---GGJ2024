extends Area2D

class_name FaceClicker

enum FaceStatus {
	IDLE,
	GRIMACE_0,
	GRIMACE_1,
	GRIMACE_2,
	FULL_GRIMACE,
	FULL_GRIMACE_ATTACK
}

signal face_status_changed(status: FaceStatus)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var click_stream: AudioStreamPlayer = $face_click

var face_status: FaceStatus = FaceStatus.IDLE:
	set(value):
		if value != face_status:
			face_status = value
			face_status_changed.emit(value)
			match face_status:
				FaceStatus.IDLE:
					animated_sprite.play("idle")
				FaceStatus.GRIMACE_0:
					animated_sprite.play("grimace_0")
				FaceStatus.GRIMACE_1:
					animated_sprite.play("grimace_1")
				FaceStatus.GRIMACE_2:
					animated_sprite.play("grimace_2")
				FaceStatus.FULL_GRIMACE:
					($LoseFaceTimer as Timer).stop()
					animated_sprite.play("grimace_full")
					($smorfia as AudioStreamPlayer).play()
					anim_player.play("grimace_attack")

var face_clicks: int = 0:
	set(value):
		face_clicks = clamp(value, 0, 10)
		var tween: Tween = get_tree().create_tween()
		var new_scale: float = 1
		if face_clicks >= 10:
			face_status = FaceStatus.FULL_GRIMACE
			new_scale = 1.4
		elif face_clicks >= 7:
			face_status = FaceStatus.GRIMACE_2
			new_scale = 1.3
		elif face_clicks >= 4:
			face_status = FaceStatus.GRIMACE_1
			new_scale = 1.2
		elif face_clicks >= 1:
			face_status = FaceStatus.GRIMACE_0
			new_scale = 1.1
		else:
			face_status = FaceStatus.IDLE
		
		tween.tween_property(self, "scale", Vector2(new_scale, new_scale), 0.2)


func attack_anim_finished() -> void:
	face_status = FaceStatus.FULL_GRIMACE_ATTACK
	($LoseFaceTimer as Timer).start()
	face_clicks = 0
	click_stream.pitch_scale = 1


func _on_lose_face_timer_timeout() -> void:
	face_clicks -= 1
	if not click_stream.pitch_scale <= 1:
		click_stream.pitch_scale = click_stream.pitch_scale - 0.3


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and event.is_released() and not anim_player.is_playing():
		face_clicks += 1
		click_stream.pitch_scale = click_stream.pitch_scale + 0.3
		click_stream.play()

