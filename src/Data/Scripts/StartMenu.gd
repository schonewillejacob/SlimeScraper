extends Control

@onready var spinBox = get_node("VBoxContainer/HBoxContainer/SpinBox")


func _ready():
	# This should access highscores, check the top result, and have it's max be that value.
	spinBox.max_value = 20.0 
	spinBox.min_value = 0.0



func start_game():
	GameController.difficulty = spinBox.value
	print("starting new game at diffculty "+str(GameController.difficulty))
	get_tree().change_scene_to_file("res://Data/Scenes/PlayArea.tscn")
	
func exit_game():
	get_tree().quit()
	
func options():
	pass
