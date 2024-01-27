extends Area2D

class_name Boss

signal boss_status_changed(status: BossStatus)
signal boss_blocked_damage()
signal boss_second_phase()
signal boss_dead()

enum BossStatus {
	EARS_COVERED_TUTORIAL,
	EYES_COVERED_TUTORIAL,
	ARMS_UP_TUTORIAL,
	EARS_COVERED,
	EYES_COVERED,
	ARMS_UP,
	ATTACK,
	DIALOGUE,
	DAMAGE
}


enum AttackType {
	JOKE,
	HALF_GRIMACE,
	FULL_GRIMACE,
	TICKLE,
	TICKLE_LIGHT
}

@onready var attack_timer: Timer = $AttackTimer
@onready var attack_pb: ProgressBar = $AttackPb
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var defence_mode_timer: Timer = $DefenceModeTimer
@onready var boss_sprite: AnimatedSprite2D = $Node2D/Boss
@onready var bullet_marker: Marker2D = $Node2D/Boss/Marker2D
@onready var active_material: ShaderMaterial = ($Node2D/Boss as AnimatedSprite2D).material

var defence_modes: Array[BossStatus] = [BossStatus.EARS_COVERED,BossStatus.EYES_COVERED,BossStatus.ARMS_UP]
var previous_defence_mode: BossStatus = BossStatus.DIALOGUE
var possible_attack_words: Array[String] = ["I HATE YOU", "YOU ARE A FAILURE", "NO ONE LOVES YOU", "DISAPPOINTMENT", "FEAR", "PARASITE", "DEATH", "USELESS", "NO NO NO NO", "GO AWAY"]
var currently_processed_attack_word: String = "" 


var boss_status: BossStatus = BossStatus.DIALOGUE:
	set(value):
		boss_status = value
		boss_status_changed.emit(boss_status)
		match boss_status:
			BossStatus.EARS_COVERED_TUTORIAL:
				boss_sprite.play("ears_covered")
				print("TUTORIAL EARS")
			BossStatus.EYES_COVERED_TUTORIAL:
				print("TUTORIAL EYES")
			BossStatus.ARMS_UP_TUTORIAL:
				print("TUTORIAL ARMS")
			BossStatus.EARS_COVERED:
				boss_sprite.play("ears_covered")
				
				attack_pb.visible = true
				attack_timer.start()
				attack_pb.value = 0
				print ("EARS_COVERED")
			BossStatus.EYES_COVERED:
				boss_sprite.play("eyes_covered")
				attack_pb.visible = true
				attack_timer.start()
				attack_pb.value = 0
				print ("EYES_COVERED")
			BossStatus.ARMS_UP:
				boss_sprite.play("arms_up")
				attack_pb.visible = true
				attack_timer.start()
				attack_pb.value = 0
				print ("ARMS_UP")
			BossStatus.ATTACK:
				boss_sprite.play("attack")
				attack_pb.visible = false
				($wolf_attack as AudioStreamPlayer).play()
				if GameStats.second_phase:
					attack_timer.wait_time = GameStats.boss_attack_timer_phase2
					attack_pb.max_value = GameStats.boss_attack_timer_phase2
					animation_player.play("attacking_phase2")
				else:
					attack_timer.wait_time = GameStats.boss_attack_timer
					attack_pb.max_value = GameStats.boss_attack_timer
					animation_player.play("attacking")

			BossStatus.DIALOGUE:
				boss_sprite.play("defaut")
			BossStatus.DAMAGE:
				print ("BOSS TAKES DAMAGE")
				boss_sprite.play("smile")
				attack_pb.visible = false
				attack_timer.stop()
				animation_player.play("damage")
				($wolf_hit as AudioStreamPlayer).play()


func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)
	attack_timer.wait_time = GameStats.boss_attack_timer
	attack_pb.max_value = GameStats.boss_attack_timer
	attack_pb.value = 0
	attack_pb.visible = false
	defence_mode_timer.wait_time = GameStats.boss_defence_switch_timer


func _process(_delta: float) -> void:
	attack_pb.value = attack_pb.max_value - attack_timer.time_left
	if attack_pb.value >= 8.0 and not animation_player.is_playing():
		animation_player.play("attack_charged")


func boss_attacked(type: AttackType) -> void:
	if boss_status == BossStatus.DAMAGE:
		print ("already taking damage")
		pass
	match type:
		AttackType.JOKE:
			if boss_status == BossStatus.EYES_COVERED:
				take_damage()
			else:
				boss_blocked_damage.emit()
				attack_timer.stop()
				attack_pb.visible = false
				Dialogic.start("joke_ineffective")
		AttackType.FULL_GRIMACE:
			if boss_status == BossStatus.EARS_COVERED:
				take_damage()
			else:
				boss_blocked_damage.emit()
				attack_timer.stop()
				attack_pb.visible = false
				Dialogic.start("smorfia_ineffective")
		AttackType.TICKLE:
			if boss_status == BossStatus.ARMS_UP:
				take_damage()
			else:
				boss_blocked_damage.emit()
				attack_timer.stop()
				attack_pb.visible = false
				Dialogic.start("feather_ineffective")
		AttackType.TICKLE_LIGHT:
			if boss_status == BossStatus.ARMS_UP:
				set_shader_value(20.0)
				var tween: Tween = get_tree().create_tween()
				tween.tween_method(set_shader_value, 20.0, 1.0, 0.5)


func set_shader_value(value: float) -> void:
	active_material.set_shader_parameter("Strength", value)


func take_damage() -> void:
	boss_status = BossStatus.DAMAGE


func block_damage() -> void:
	boss_blocked_damage.emit()
	boss_status = BossStatus.ATTACK


func new_defence_mode() -> void:
	if GameStats.second_phase:
		($Node2D/nervetto as TextureRect).visible = true
	roll_new_defence_mode()


func roll_new_defence_mode() -> void:
	var new_mode: BossStatus = defence_modes[randi() % defence_modes.size()]
	check_new_defence_mode(new_mode)


func check_new_defence_mode(new_mode: BossStatus) -> void:
	if new_mode == previous_defence_mode:
		roll_new_defence_mode()
		pass
	else:
		boss_status = new_mode
		previous_defence_mode = new_mode


func _attack_finished() -> void:
	new_defence_mode()


func _damage_finished() -> void:
	GameStats.boss_health = GameStats.boss_health - 1
	if GameStats.boss_health == GameStats.second_phase_start_health:
		boss_second_phase.emit()
	elif GameStats.boss_health <= 0:
		boss_dead.emit()
	else:
		new_defence_mode()


func _on_defence_mode_timer_timeout() -> void:
	new_defence_mode()


func _on_attack_timer_timeout() -> void:
	boss_status = BossStatus.ATTACK


func DialogicSignal(argument:String) -> void:
	if argument == "attack_blocked_end":
		block_damage()


func get_next_bullet_data() -> Dictionary:
	var dic_to_return: Dictionary = {"position": bullet_marker.global_position, "letter": currently_processed_attack_word.erase(0, 1)}
	if currently_processed_attack_word.length() == 0:
		currently_processed_attack_word = possible_attack_words.pick_random()
		return dic_to_return


	dic_to_return["letter"] = currently_processed_attack_word[0]
	currently_processed_attack_word = currently_processed_attack_word.erase(0, 1)


	return dic_to_return


func start_tutorial() -> void:
	boss_status = BossStatus.EARS_COVERED_TUTORIAL
