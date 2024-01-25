extends Control

enum BossStatus {
	EARS_COVERED,
	EYES_COVERED,
	ARMS_UP,
	ATTACK,
	DIALOGUE,
	DAMAGE
}

signal boss_status_changed(status: BossStatus)
signal boss_take_damage()
signal boss_blocked_damage()

var previous_defence_mode: BossStatus

var boss_status: BossStatus = BossStatus.DIALOGUE:
	set(value):
		boss_status = value
		match boss_status:
			BossStatus.EARS_COVERED:
				$BossFace/Label.text = "EARS_COVERED"
				boss_status_changed.emit("EARS_COVERED")
			BossStatus.EYES_COVERED:
				$BossFace/Label.text = "EYES_COVERED"
				boss_status_changed.emit("EYES_COVERED")
			BossStatus.ARMS_UP:
				$BossFace/Label.text = "ARMS_UP"
				boss_status_changed.emit("ARMS_UP")
			BossStatus.ATTACK:
				$BossFace/Label.text = "ATTACK"
				boss_status_changed.emit("ATTACK")
			BossStatus.DIALOGUE:
				$BossFace/Label.text = "DIALOGUE"
				boss_status_changed.emit("DIALOGUE")
			BossStatus.DAMAGE:
				$BossFace/Label.text = "DAMAGE"
				boss_status_changed.emit("DAMAGE")


func boss_attacked(type):
	if type == "joke":
		if boss_status == BossStatus.EYES_COVERED:
			boss_take_damage.emit()
			boss_status = BossStatus.DAMAGE
		else:
			boss_blocked_damage.emit()
			boss_status = BossStatus.ATTACK
	if type == "funny_face":
		if boss_status == BossStatus.EARS_COVERED:
			boss_take_damage.emit()
			boss_status = BossStatus.DAMAGE
		else:
			boss_blocked_damage.emit()
			boss_status = BossStatus.ATTACK
	if type == "feather":
		if boss_status == BossStatus.ARMS_UP:
			boss_take_damage.emit()
			boss_status = BossStatus.DAMAGE
		else:
			boss_blocked_damage.emit()
			boss_status = BossStatus.ATTACK


func new_defence_mode() -> void:
	roll_new_defence_mode()


func roll_new_defence_mode():
	var new_mode = BossStatus.keys()[randi() % BossStatus.size()]
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
