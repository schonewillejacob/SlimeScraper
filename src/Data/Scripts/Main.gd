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
@onready var class_playArea = preload("res://Data/Scenes/PlayArea.tscn")
@onready var scores_path : String = "user://highscore.json"
@onready var base_scores_path : String = "res://Data/Scripts/JSON/highscore.json"


var base_score_file = {
	"1" : {
		"name":"n/a",
		"score":0
	},
	"2" : {
		"name":"n/a",
		"score":0
	},
	"3" : {
		"name":"n/a",
		"score":0
	},
	"4" : {
		"name":"n/a",
		"score":0
	},
	"5" : {
		"name":"n/a",
		"score":0
	}
}



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
		print("File not present, creating default...")
		var new_file = FileAccess.open(scores_path, FileAccess.WRITE)
		new_file.store_line(var_to_str(base_score_file))
		new_file.close()
		fill_score_labels()



func exit_game():
	get_tree().quit()

func start_game():
	print("starting new game at diffculty "+str(GameController.difficulty))
	GameController.difficulty = spinBox.value
	GameController.musicSync = audioPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://Data/Scenes/PlayArea.tscn")
