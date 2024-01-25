extends Control


enum FaceStatus {
	NORMAL,
	HALF_GRIMACE,
	FULL_GRIMACE
}

signal face_status_changed(status: FaceStatus)