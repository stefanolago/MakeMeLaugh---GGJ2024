extends Control


@onready var feather_scene: Control = $Feather
@onready var boss_portrait_scene: Control = $BossFace


func _ready() -> void:
	(feather_scene as FeatherScene).shake_zone = boss_portrait_scene


func _on_face_clicker_face_status_changed(status: FaceClicker.FaceStatus) -> void:
	match status:
		FaceClicker.FaceStatus.HALF_GRIMACE:
			player_attack(Boss.AttackType.HALF_GRIMACE)
		FaceClicker.FaceStatus.FULL_GRIMACE:
			player_attack(Boss.AttackType.GRIMACE)


func _on_feather_tickled() -> void:
	player_attack(Boss.AttackType.TICKLE_LIGHT)


func _on_feather_finished_tickling() -> void:
	player_attack(Boss.AttackType.TICKLE)


func player_attack(attack_type: Boss.AttackType) -> void:
	($BossFace as Boss).boss_attacked(attack_type)


func _on_joke_typing_inserted_right_word() -> void:
	player_attack(Boss.AttackType.JOKE)
