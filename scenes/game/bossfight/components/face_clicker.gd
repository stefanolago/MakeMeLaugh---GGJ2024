extends Control


enum FaceStatus {
	NORMAL,
	HALF_GRIMACE,
	FULL_GRIMACE
}

signal face_status_changed(status: FaceStatus)

var face_status: FaceStatus = FaceStatus.NORMAL:
	set(value):
		if value != face_status:
			face_status_changed.emit(value)
		face_status = value


var face_clicks: int = 0:
	set(value):
		face_clicks = value if value > 0 else 0
		if face_clicks >= 10:
			face_status = FaceStatus.FULL_GRIMACE
		elif face_clicks >= 5:
			face_status = FaceStatus.HALF_GRIMACE
		else:
			face_status = FaceStatus.NORMAL


func _on_button_pressed() -> void:
	face_clicks += 1


func _on_lose_face_timer_timeout() -> void:
	face_clicks -= 1
