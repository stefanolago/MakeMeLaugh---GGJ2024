extends Control

class_name Boss

signal boss_status_changed(status: BossStatus)
signal boss_blocked_damage()

enum BossStatus {
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

var defence_modes: Array[BossStatus] = [BossStatus.EARS_COVERED,BossStatus.EYES_COVERED,BossStatus.ARMS_UP]
var previous_defence_mode: BossStatus = BossStatus.DIALOGUE

@onready var attack_timer: Timer = $attack_timer
@onready var attack_pb: ProgressBar = $boss/attack_pb
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var defence_mode_timer: Timer = $defence_mode_timer


var boss_status: BossStatus = BossStatus.DIALOGUE:
	set(value):
		boss_status = value
		match boss_status:
			BossStatus.EARS_COVERED:
				$boss/BossFace/Label.text = "EARS_COVERED"
				boss_status_changed.emit("EARS_COVERED")
				attack_pb.visible = true
				attack_timer.start()
				attack_pb.value = 0
				print ("EARS_COVERED")
			BossStatus.EYES_COVERED:
				$boss/BossFace/Label.text = "EYES_COVERED"
				boss_status_changed.emit("EYES_COVERED")
				attack_pb.visible = true
				attack_timer.start()
				attack_pb.value = 0
				print ("EYES_COVERED")
			BossStatus.ARMS_UP:
				$boss/BossFace/Label.text = "ARMS_UP"
				boss_status_changed.emit("ARMS_UP")
				attack_pb.visible = true
				attack_timer.start()
				attack_pb.value = 0
				print ("ARMS_UP")
			BossStatus.ATTACK:
				$boss/BossFace/Label.text = "ATTACK"
				boss_status_changed.emit("ATTACK")
				animation_player.play("attacking")
				attack_pb.visible = false
				($wolf_attack as AudioStreamPlayer).play()
			BossStatus.DIALOGUE:
				$boss/BossFace/Label.text = "DIALOGUE"
				boss_status_changed.emit("DIALOGUE")
			BossStatus.DAMAGE:
				print ("BOSS TAKES DAMAGE")
				$boss/BossFace/Label.text = "DAMAGE"
				boss_status_changed.emit("DAMAGE")
				attack_pb.visible = false
				attack_timer.stop()
				animation_player.play("damage")
				($wolf_hit as AudioStreamPlayer).play()


func _ready() -> void:
	attack_timer.wait_time = GameStats.boss_attack_timer
	attack_pb.max_value = GameStats.boss_attack_timer
	attack_pb.value = 0
	attack_pb.visible = false
	defence_mode_timer.wait_time = GameStats.boss_defence_switch_timer


func _process(_delta: float) -> void:
	attack_pb.value = attack_pb.max_value - attack_timer.time_left


func boss_attacked(type: AttackType) -> void:
	if boss_status == BossStatus.DAMAGE:
		print ("already taking damage")
		pass
	match type:
		AttackType.JOKE:
			if boss_status == BossStatus.EYES_COVERED:
				take_damage()
			else:
				block_damage()
		AttackType.FULL_GRIMACE:
			if boss_status == BossStatus.EARS_COVERED:
				take_damage()
			else:
				block_damage()
		AttackType.TICKLE:
			if boss_status == BossStatus.ARMS_UP:
				take_damage()
			else:
				block_damage()
		AttackType.TICKLE_LIGHT:
			if boss_status == BossStatus.ARMS_UP:
				print("TICKLE LIGHT")


func take_damage() -> void:
	boss_status = BossStatus.DAMAGE
	print ("boss took damage")


func block_damage() -> void:
	boss_blocked_damage.emit()
	boss_status = BossStatus.ATTACK
	print ("boss blocked")


func new_defence_mode() -> void:
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
	new_defence_mode()


func _on_defence_mode_timer_timeout() -> void:
	new_defence_mode()


func _on_attack_timer_timeout() -> void:
	boss_status = BossStatus.ATTACK


func _on_begin_battle_timer_timeout() -> void:
	new_defence_mode()


func _on_debug_attack_pressed():
	boss_status = BossStatus.ATTACK
