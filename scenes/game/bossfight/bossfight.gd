extends Control


@onready var feather_scene: Control = $Feather
@onready var boss_portrait_scene: Control = $BossFace


func _ready() -> void:
	(feather_scene as FeatherScene).shake_zone = boss_portrait_scene


func _on_face_clicker_face_status_changed(status: FaceClicker.FaceStatus) -> void:
	print(status)


func _on_feather_tickled() -> void:
	print("BOSSFIGHT TICKLED")


func _on_feather_finished_tickling() -> void:
	print("BOSSFIGHT FINISHED TICKLING")
