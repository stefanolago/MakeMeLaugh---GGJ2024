extends Node2D

class_name GirlFace

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _on_area_2d_body_entered(_body:Node2D) -> void:
	print("HIT")
