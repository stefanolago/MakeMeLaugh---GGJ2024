extends Control


@onready var feather_scene: FeatherScene = $Feather
@onready var typing_scene: Control = $JokeTyping
@onready var face_clicker_scene: Control = $FaceClicker
@onready var boss_portrait_scene: Area2D = $BossFace
@onready var boss_bullet_timer: Timer = $boss_bullet_timer
@onready var boss_bullet: PackedScene = preload("res://scenes/game/bossfight/components/bullet.tscn")


func player_attack(attack_type: Boss.AttackType) -> void:
	($BossFace as Boss).boss_attacked(attack_type)

func player_fails() -> void:
	#TO DO se vogliamo
	pass


func spawn_bullet() -> void:
	print ("spawn bullet")
	var boss_pos = ($BossFace/boss_fire as Marker2D).position
	var bullet_instance = boss_bullet.instantiate()
	bullet_instance.position = boss_pos
	add_child(bullet_instance)
	

func _on_face_clicker_face_status_changed(status: FaceClicker.FaceStatus) -> void:
	match status:
		FaceClicker.FaceStatus.HALF_GRIMACE:
			player_attack(Boss.AttackType.HALF_GRIMACE)
		FaceClicker.FaceStatus.FULL_GRIMACE:
			player_attack(Boss.AttackType.FULL_GRIMACE)


func _on_feather_tickled() -> void:
	player_attack(Boss.AttackType.TICKLE_LIGHT)


func _on_feather_finished_tickling() -> void:
	print ("tickled")
	player_attack(Boss.AttackType.TICKLE)


func _on_joke_typing_inserted_right_word() -> void:
	player_attack(Boss.AttackType.JOKE)

func _on_joke_typing_inserted_wrong_word() -> void:
	player_fails()

func _on_boss_face_boss_status_changed(status:String) -> void:
	match status:
		"ATTACK":
			typing_scene.visible = false
			feather_scene.visible = false
			face_clicker_scene.visible = false
			boss_bullet_timer.start()
		"DAMAGE":
			typing_scene.visible = false
			feather_scene.visible = false
			face_clicker_scene.visible = false
		_:
			typing_scene.visible = true
			feather_scene.visible = true
			face_clicker_scene.visible = true
			boss_bullet_timer.stop()


func _on_boss_bullet_timer_timeout() -> void:
	spawn_bullet()
