extends Control

enum FeatherState {
	NORMAL,
	IN_HAND,
	IN_HAND_AND_TICKLING
}


signal tickled()
signal finished_tickling()


@onready var feather_button: Button = $ClickableArea
@onready var feather_texture: TextureRect = $FeatherTexture
@onready var base_modulate: Color = ($ClickableArea as Button).modulate


var shake_zone: Control:
	set(value):	
		print("SET SHAKE ZONE")
		shake_zone.connect("mouse_entered", _on_mouse_entered_in_shake_zone)
		shake_zone.connect("mouse_exited", _on_mouse_exited_shake_zone)


var shake_meter: int = 0:
	set(value):
		shake_meter = value
		if shake_meter % 50 == 0:
			tickled.emit()
		if shake_meter > total_shake_meter_to_reach:
			finished_tickling.emit()


var feather_state: FeatherState = FeatherState.NORMAL:
	set(value):
		feather_state = value
		if feather_state == FeatherState.IN_HAND:
			feather_button.modulate = Color.BLACK
			feather_texture.visible = true
		else:
			feather_button.modulate = base_modulate
			feather_texture.visible = false



var minimum_frames_to_register_shake: float = 300.0
var total_shake_meter_to_reach: int = 400


func _on_mouse_entered_in_shake_zone() -> void:
	print("ON MOUSE ENTERED SHAKE")


func _on_mouse_exited_shake_zone() -> void:
	print("ON MOUSE EXITED SHAKE ZONE")


func _on_clickable_area_pressed() -> void:
	feather_state = FeatherState.IN_HAND


func set_tickling(tickling: bool) -> void:
	if tickling and feather_state == FeatherState.IN_HAND:
		feather_state = FeatherState.IN_HAND_AND_TICKLING
	elif not tickling and feather_state == FeatherState.IN_HAND_AND_TICKLING:
		feather_state = FeatherState.IN_HAND


func _input(event: InputEvent) -> void:
	if (feather_state == FeatherState.IN_HAND_AND_TICKLING or feather_state == FeatherState.IN_HAND) and event is InputEventMouseMotion:
		feather_texture.global_position = get_global_mouse_position() - feather_texture.size / 2
		if feather_state == FeatherState.IN_HAND_AND_TICKLING and (event as InputEventMouseMotion).relative.length_squared() > minimum_frames_to_register_shake:
			shake_meter += 1
			
		#if (event as InputEventMouseMotion).relative.length_squared()
	if event is InputEventMouseButton and event.is_released():
		feather_state = FeatherState.NORMAL
	
