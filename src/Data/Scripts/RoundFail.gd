extends Control



var try_count = 0
@onready var scores_path : String = "user://highscore.json"
@onready var base_scores_path : String = "res://Data/Scripts/JSON/highscore.json"
@onready var submit_form = $HBoxContainer/player_name



# Called when the node enters the scene tree for the first time.
func _ready():
	$points_label.text = "Points: "+str(GameController.score)



func submit_score():
	if submit_form.text != "":	
		print("quitting") 
		write_score()
		GameController.score = 0
		get_tree().change_scene_to_file("res://Data/Scenes/Main.tscn")
	else:
		print("Failed: empty form")
		$HBoxContainer/submit_button/denied.play()

func write_score():
	if GameController.score < 1:
		return
	if FileAccess.file_exists(scores_path):
#		Load data
		var json_as_text = FileAccess.get_file_as_string(scores_path)
		var json_as_dict = JSON.parse_string(json_as_text)
#		Reference for substitution
		var prev_entry_name
		var prev_entry_score
		var flag_writedownward : bool = false
#		Read from disk
		if json_as_dict:
			for entry in json_as_dict:
				if json_as_dict[entry].score < GameController.score || flag_writedownward || json_as_dict[entry].score == 0:
					if !flag_writedownward:
						prev_entry_name = json_as_dict[entry].name
						json_as_dict[entry].name = submit_form.text
						prev_entry_score = json_as_dict[entry].score
						json_as_dict[entry].score = GameController.score
					else:
						var temp = prev_entry_name
						prev_entry_name = json_as_dict[entry].name
						json_as_dict[entry].name = temp
						
						temp = prev_entry_score
						prev_entry_score = json_as_dict[entry].score
						json_as_dict[entry].score = temp
					flag_writedownward = true
#			Write to disk
			var temp_file = FileAccess.open(scores_path, FileAccess.WRITE)
			temp_file.store_line(var_to_str(json_as_dict))
			temp_file.close()

