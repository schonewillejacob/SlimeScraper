extends Control



var try_count = 0
@onready var scores_path : String = "user://highscore.json"
@onready var base_scores_path : String = "res://Data/Scripts/JSON/highscore.json"



# Called when the node enters the scene tree for the first time.
func _ready():
	$points_label.text = "Points: "+str(GameController.score)
	GameController.score = 0



func submit_score():
	print("quitting")
	write_score()
	get_tree().change_scene_to_file("res://Data/Scenes/Main.tscn")
	pass

func write_score():
	if FileAccess.file_exists(scores_path):
		var json_as_text = FileAccess.get_file_as_string(scores_path)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			for entry in json_as_dict:
				var score_string = str(json_as_dict[entry].score) + " - " +json_as_dict[entry].name 
	else:
		print("File not present, loading default...")
		if FileAccess.file_exists(base_scores_path):
			var json_as_text = FileAccess.get_file_as_string(scores_path)
			var json_as_dict = JSON.parse_string(json_as_text)
			try_count += 1
			if try_count > 2:
				print("ERROR: try_count exceeded, base highscore.json missing?")
				return
			write_score()
