extends Control


func _on_face_clicker_face_status_changed(status:int) -> void:
	print("STATUS: ")
	print(status)

func player_attack(attack_type):
	$BossFace.boss_attacked(attack_type)

func _on_joke_typing_inserted_right_word(attack_type):
	player_attack(attack_type)
