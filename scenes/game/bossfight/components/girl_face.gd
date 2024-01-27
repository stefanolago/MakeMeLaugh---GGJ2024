extends Node2D

class_name GirlFace

signal player_dead()

enum State {
	NORMAL,
	INVINCIBLE
}

var state: State = State.NORMAL
var can_move: bool = true


@onready var invincible_timer: Timer = $InvincibilityTimer
@onready var block_move_timer: Timer = $block_move_timer
@onready var active_material: ShaderMaterial = ($Sprite2D as Sprite2D).material

@export var min_position: Marker2D
@export var max_position: Marker2D
@export var speed: float = 10


func _ready() -> void:
	invincible_timer.wait_time = GameStats.invincibility_time
	block_move_timer.wait_time = GameStats.block_move_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible and can_move:
		var clamped_mouse_pos: Vector2 = get_global_mouse_position()
		clamped_mouse_pos.x = clampf(clamped_mouse_pos.x, min_position.global_position.x, max_position.global_position.x)
		clamped_mouse_pos.y = clampf(clamped_mouse_pos.y, min_position.global_position.y, max_position.global_position.y)
		global_position = clamped_mouse_pos

		Input.warp_mouse(clamped_mouse_pos)


func _on_area_2d_body_entered(body:Node2D) -> void:
	body.queue_free()
	if state != State.INVINCIBLE:
		GameStats.player_health -= 1
		state = State.INVINCIBLE
		can_move = false
		invincible_timer.start()
		block_move_timer.start()
		active_material.set_shader_parameter("Strength", 30)
		if GameStats.player_health <= 0:
			player_dead.emit()


func _on_invincibility_timer_timeout() -> void:
	state = State.NORMAL
	active_material.set_shader_parameter("Strength", 2)


func _on_block_move_timer_timeout() -> void:
	print ("can move again")
	can_move = true
