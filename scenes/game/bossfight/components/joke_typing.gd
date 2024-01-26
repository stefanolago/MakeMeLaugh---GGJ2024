extends Control


signal inserted_correct_letter()
signal inserted_wrong_letter()
signal inserted_right_word()
signal inserted_wrong_word()

@onready var joke_display: Label = $joke_UI/Joke_display
@onready var player_input: LineEdit = $joke_UI/player_input


var jokes: Array[String] = [
	"Bamboozle",
	"Discombabulate",
	"Gobbledygook",
	"Bunghole",
	"Skidaddle",
	"Dingus"
	]
var current_joke : String = ""

func _ready() -> void:
	write_joke()


func write_joke() -> void:
	var new_joke: String = jokes[randi() % jokes.size()]
	while(new_joke == current_joke):
		new_joke = jokes[randi() % jokes.size()]
	current_joke = new_joke
	joke_display.text = current_joke
	player_input.text = ""


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		check_input()


func check_input() -> void:
	var is_good: bool = player_input.text.strip_edges() == current_joke
	if is_good:
		($AnimationPlayer as AnimationPlayer).play("right_joke")
	else:
		($AnimationPlayer as AnimationPlayer).play("wrong_joke")


func wrong_joke_anim_played() -> void:
	inserted_wrong_word.emit()
	write_joke()


func right_joke_anim_played() -> void:
	inserted_right_word.emit()
	write_joke()
