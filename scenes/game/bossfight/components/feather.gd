extends Node2D

class_name FeatherScene

enum FeatherState {
	NORMAL,
	IN_HAND,
	IN_HAND_AND_TICKLING
}


signal tickled()
signal finished_tickling()

@onready var feather_area: Area2D = $FeatherActive


var shake_meter: int = 0:
	set(value):
		shake_meter = value
		if shake_meter % 50 == 0:
			tickled.emit()
		if shake_meter > total_shake_meter_to_reach:
			finished_tickling.emit()


var feather_state: FeatherState = FeatherState.NORMAL
var minimum_frames_to_register_shake: float = 200.0
@export var total_shake_meter_to_reach: int = 200


func _input(event: InputEvent) -> void:
	if (feather_state == FeatherState.IN_HAND_AND_TICKLING or feather_state == FeatherState.IN_HAND) and event is InputEventMouseMotion:
		feather_area.global_position = get_global_mouse_position()
		if feather_state == FeatherState.IN_HAND_AND_TICKLING and (event as InputEventMouseMotion).relative.length_squared() > minimum_frames_to_register_shake:
			shake_meter += 1
			
		#if (event as InputEventMouseMotion).relative.length_squared()
	if event is InputEventMouseButton and event.is_released():
		feather_state = FeatherState.NORMAL
	

func _on_feather_active_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			reset_to_normal()
		else:
			feather_state = FeatherState.IN_HAND

func reset_to_normal() -> void:
	feather_state = FeatherState.NORMAL
	feather_area.global_position = global_position


func _on_feather_active_area_entered(_area:Area2D) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		feather_state = FeatherState.IN_HAND_AND_TICKLING


func _on_feather_active_area_exited(_area:Area2D) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		feather_state = FeatherState.IN_HAND