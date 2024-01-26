extends Node2D

class_name GirlFace

enum State {
	NORMAL,
	INVINCIBLE
}

var state: State = State.NORMAL
@onready var invincible_timer: Timer = $InvincibilityTimer
@onready var active_material: ShaderMaterial = ($Sprite2D as Sprite2D).material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _on_area_2d_body_entered(body:Node2D) -> void:
	body.queue_free()
	if state != State.INVINCIBLE:
		GameStats.girl_health -= 1
		state = State.INVINCIBLE
		invincible_timer.start()
		active_material.set_shader_parameter("Strength", 20)


func _on_invincibility_timer_timeout() -> void:
	state = State.NORMAL
	active_material.set_shader_parameter("Strength", 2)
