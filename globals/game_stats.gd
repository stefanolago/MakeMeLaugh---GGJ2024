extends Node

signal start_second_phase()

var boss_attack_timer: int
var boss_attack_timer_phase2: int
var boss_defence_switch_timer: int
var boss_health: int
var second_phase_start_health: int
var player_health: int
var invincibility_time: float
var block_move_time: float
var second_phase: bool:
	set(value):
		second_phase = value
		start_second_phase.emit()



var second_phase_bullet_vel: int

var show_tutorial: bool = true

func _ready() -> void:
	reset()


func reset() -> void:
	print ("restarting")
	boss_attack_timer = 8
	boss_attack_timer_phase2 = 5
	boss_defence_switch_timer = 20
	boss_health = 10
	second_phase_start_health = 5
	player_health = 5
	invincibility_time = 1.0
	block_move_time = 0.5
	second_phase = false
	second_phase_bullet_vel = 300
