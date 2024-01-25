extends Control

signal boss_status_changed(status: BossStatus)
signal boss_take_damage()
signal boss_blocked_damage()

enum BossStatus {
	EARS_COVERED,
	EYES_COVERED,
	ARMS_UP,
	ATTACK,
	DIALOGUE,
	DAMAGE
}

var defence_modes: Array[BossStatus] = [BossStatus.EARS_COVERED,BossStatus.EYES_COVERED,BossStatus.ARMS_UP]
var previous_defence_mode = BossStatus.DIALOGUE
var boss_status: BossStatus = BossStatus.DIALOGUE

@onready var attack_timer = $attack_timer
@onready var attack_pb = $attack_pb

func _ready():
	attack_timer.wait_time = GameStats.boss_attack_timer
	attack_pb.max_value = GameStats.boss_attack_timer


func _process(delta):
	attack_pb.value = attack_pb.max_value - attack_timer.time_left


func boss_attacked(type):
	if type == "JOKE":
		if boss_status == BossStatus.EYES_COVERED:
			take_damage()
		else:
			block_damage()
	if type == "FUNNYFACE":
		if boss_status == BossStatus.EARS_COVERED:
			take_damage()
		else:
			block_damage()
	if type == "FEATHER":
		if boss_status == BossStatus.ARMS_UP:
			take_damage()
		else:
			block_damage()


func take_damage() -> void:
	boss_take_damage.emit()
	boss_status = BossStatus.DAMAGE
	print ("boss took damage")


func block_damage() -> void:
	boss_blocked_damage.emit()
	boss_status = BossStatus.ATTACK
	print ("boss blocked")


func new_defence_mode() -> void:
	roll_new_defence_mode()


func roll_new_defence_mode() -> void:
	var new_mode = defence_modes[randi() % defence_modes.size()]
	check_new_defence_mode(new_mode)


func check_new_defence_mode(new_mode):
	if new_mode == previous_defence_mode:
		roll_new_defence_mode()
		pass
	else:
		boss_status = new_mode
		previous_defence_mode = new_mode


func _on_defence_mode_timer_timeout():
	new_defence_mode()
