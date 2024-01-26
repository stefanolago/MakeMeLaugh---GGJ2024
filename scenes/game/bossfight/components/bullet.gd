extends Node2D

class_name BossBullet

var letter: String = "A"

@onready var label: Label = $Group/RigidBody2D/Label

func set_letter(value: String) -> void:
	letter = value
	if label != null:
		label.text = letter


func _ready() -> void:
	label.text = letter

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
