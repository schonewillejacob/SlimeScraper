extends Node2D
# This scene contains the main menu

@onready var spinBox = $Menu/HBoxContainer/SpinBox
@onready var audioPlayer = self.get_parent().get_node("ASP")
@onready var class_playArea = preload("res://Data/Scenes/PlayArea.tscn")
@onready var save_path = "user://highscore.save"


# Called when the node enters the scene tree for the first time.
func _ready():
#	This should access highscores, check the top result, and have it's max be that value.
	spinBox.max_value = 20.0 
	spinBox.min_value = 0.0
	load_score()

func load_score():
	if FileAccess.file_exists(save_path):
		var f = FileAccess.open(save_path, FileAccess.READ)
		var content = f.get_as_text()
		print(content)
		f.close()

func exit_game():
	get_tree().quit()

func options():
	pass

func start_game():
	GameController.difficulty = spinBox.value
	print("starting new game at diffculty "+str(GameController.difficulty))
	
	get_tree().change_scene_to_file("res://Data/Scenes/PlayArea.tscn")
