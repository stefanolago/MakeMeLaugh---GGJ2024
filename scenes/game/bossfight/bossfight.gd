extends Control


@onready var feather_scene: FeatherScene = $Feather
@onready var typing_scene: Node2D = $JokeTyping
@onready var face_clicker_scene: Area2D = $FaceClicker
@onready var boss_portrait_scene: Boss = $BossFace
@onready var boss_bullet_timer: Timer = $boss_bullet_timer
@onready var girl_face: GirlFace = $GirlFace
@onready var movement_limit:Node2D = $movement_limit
@onready var boss_bullet: PackedScene = preload("res://scenes/game/bossfight/components/bullet.tscn")
@onready var ending: PackedScene = preload("res://scenes/game/cutscenes/ending.tscn")
@onready var game_over_scene: PackedScene = preload("res://scenes/_game_over/game_over.tscn")

var phase_mult: float = 1.0

func _ready() -> void:
	hide_player_ui()
	Dialogic.signal_event.connect(DialogicSignal)
	Dialogic.start("bossfight_intro")


func player_attack(attack_type: Boss.AttackType) -> void:
	($BossFace as Boss).boss_attacked(attack_type)


func player_fails() -> void:
	#TO DO se vogliamo
	pass


func spawn_bullet(pos: Vector2, letter: String) -> void:
	var bullet_instance: BossBullet = boss_bullet.instantiate()
	bullet_instance.set_letter(letter)
	bullet_instance.position = pos
	add_child(bullet_instance)


func end_bossfight() -> void:
	TransitionLayer.change_scene(ending)


func show_player_ui() -> void:
	feather_scene.visible = true
	typing_scene.visible = true
	face_clicker_scene.visible = true


func hide_player_ui() -> void:
	feather_scene.visible = false
	typing_scene.visible = false
	face_clicker_scene.visible = false


func game_over() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	TransitionLayer.change_scene(game_over_scene)


func _on_face_clicker_face_status_changed(status: FaceClicker.FaceStatus) -> void:
	match status:
		FaceClicker.FaceStatus.FULL_GRIMACE_ATTACK:
			player_attack(Boss.AttackType.FULL_GRIMACE)
			print ("damage FULL_GRIMACE")


func _on_feather_tickled() -> void:
	player_attack(Boss.AttackType.TICKLE_LIGHT)
	print ("damage _on_feather_tickled")


func _on_feather_finished_tickling() -> void:
	player_attack(Boss.AttackType.TICKLE)
	print ("damage _on_feather_finished_tickling")


func _on_joke_typing_inserted_right_word() -> void:
	player_attack(Boss.AttackType.JOKE)
	print ("damage _on_joke_typing_inserted_right_word")

func _on_joke_typing_inserted_wrong_word() -> void:
	player_fails()

func _on_boss_face_boss_status_changed(status:String) -> void:
	match status:
		"ATTACK":
			movement_limit.visible = true
			typing_scene.visible = false
			feather_scene.reset_to_normal()
			feather_scene.visible = false
			face_clicker_scene.visible = false
			girl_face.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			boss_bullet_timer.start(0.5)
		"DAMAGE":
			movement_limit.visible = false
			typing_scene.visible = false
			feather_scene.reset_to_normal()
			feather_scene.visible = false
			girl_face.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			face_clicker_scene.visible = false
		_:
			movement_limit.visible = false
			typing_scene.visible = true
			feather_scene.visible = true
			girl_face.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			face_clicker_scene.visible = true
			boss_bullet_timer.stop()


func _on_boss_bullet_timer_timeout() -> void:
	var bullet_data: Dictionary = boss_portrait_scene.get_next_bullet_data()
	if bullet_data["letter"] != "" and bullet_data["letter"] != " ":
		spawn_bullet((bullet_data["position"] as Vector2), (bullet_data["letter"] as String))
		boss_bullet_timer.start(0.1 * phase_mult)
	else:
		if boss_portrait_scene.currently_processed_attack_word.length() > 0:
			boss_bullet_timer.start(0.3 * phase_mult)
		else:
			boss_bullet_timer.start(5 * phase_mult)


func _on_debug_end_pressed() -> void:
	end_bossfight()


func _on_boss_face_boss_dead() -> void:
	end_bossfight()


func _on_boss_face_boss_second_phase() -> void:
	Dialogic.start("second_phase")
	hide_player_ui()


func _on_boss_face_boss_blocked_damage() -> void:
	hide_player_ui()


func _on_girl_face_player_dead() -> void:
	game_over()


func DialogicSignal(argument:String) -> void:
	if argument == "bossfight_intro_end":
		($BossFace as Boss).new_defence_mode()
		show_player_ui()
	if argument == "second_phase_end":
		GameStats.second_phase = true
		phase_mult = 0.4
		($BossFace as Boss).new_defence_mode()
		show_player_ui()



