extends Node2D
# This scene contains the main menu



@onready var spinBox = $Control/Menu/HBoxContainer/SpinBox
@onready var audioPlayer = $ASP
@onready var score_labels = [
	$Control/highscores/score_1,
	$Control/highscores/score_2,
	$Control/highscores/score_3,
	$Control/highscores/score_4,
	$Control/highscores/score_5
]
var try_count = 0
@onready var class_playArea = preload("res://Data/Scenes/PlayArea.tscn")
@onready var scores_path : String = "user://highscore.json"
@onready var base_scores_path : String = "res://Data/Scripts/JSON/highscore.json"


# Called when the node enters the scene tree for the first time.
func _ready():
#	This should access highscores, check the top result, and have it's max be that value.
	spinBox.max_value = 20.0 
	spinBox.min_value = 0.0

	fill_score_labels()

	

func fill_score_labels():
	if FileAccess.file_exists(scores_path):
		var json_as_text = FileAccess.get_file_as_string(scores_path)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			for entry in json_as_dict:
				var score_string = str(json_as_dict[entry].score) + " - " +json_as_dict[entry].name 
				score_labels[int(entry)-1].text = score_string
	else:
		print("File not present, loading default...")
		if FileAccess.file_exists(base_scores_path):
			var json_as_text = FileAccess.get_file_as_string(scores_path)
			var json_as_dict = JSON.parse_string(json_as_text)
			try_count += 1
			if try_count > 2:
				print("ERROR: try_count exceeded, base highscore.json missing?")
				return
			fill_score_labels()


func exit_game():
	get_tree().quit()

func start_game():
	print("starting new game at diffculty "+str(GameController.difficulty))
	GameController.difficulty = spinBox.value
	GameController.musicSync = audioPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://Data/Scenes/PlayArea.tscn")
