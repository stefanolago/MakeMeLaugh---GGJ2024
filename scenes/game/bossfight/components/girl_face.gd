extends Node2D

class_name GirlFace

enum State {
	NORMAL,
	INVINCIBLE
}

var state: State = State.NORMAL
@onready var invincible_timer: Timer = $InvincibilityTimer
@onready var active_material: ShaderMaterial = ($Sprite2D as Sprite2D).material

@export var min_position: Marker2D
@export var max_position: Marker2D
@export var speed: float = 10


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		var direction: Vector2 = (event as InputEventMouseMotion).relative.normalized()
		var pos: Vector2 = global_position + speed * direction
		pos.x = clampf(pos.x, min_position.global_position.x, max_position.global_position.x)
		pos.y = clampf(pos.y, min_position.global_position.y, max_position.global_position.y)
		global_position = pos



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
