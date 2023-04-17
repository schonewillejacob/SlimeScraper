extends Node2D
# This scene contains the main menu



@onready var spinBox = $Control/Menu/HBoxContainer/SpinBox
@onready var audioPlayer = $ASP
@onready var class_playArea = preload("res://Data/Scenes/PlayArea.tscn")
@onready var scores_path : String = "user://highscore.json"
@onready var base_scores_path : String = "res://Data/Scripts/JSON/highscore.json"



# Called when the node enters the scene tree for the first time.
func _ready():
#	This should access highscores, check the top result, and have it's max be that value.
	spinBox.max_value = 20.0 
	spinBox.min_value = 0.0
	
	if FileAccess.file_exists(scores_path):
		var json_as_text = FileAccess.get_file_as_string(scores_path)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			print(json_as_dict)
	else:
		print("File not present, loading default...")
		var dir = DirAccess.open(base_scores_path)
		dir.copy(base_scores_path,scores_path)
	
##	Create JSON
#	var json_inst = JSON.new()
#	var json_string = JSON.stringify(highscore_base)
##	Guard against errors
#	var json_error = json_inst.parse(json_string)
#	print(json_inst)
##	Process data and store locally.
#	if !json_error:
#		var f = FileAccess.open(scores_path, FileAccess.WRITE)
#		f.store_var(json_inst.data)
#		for entry in json_inst.data:
#			var this_entry = json_inst.data[entry]
#			print(this_entry.name+str(this_entry.score))
#		f.close()
#		print("Scores saved!")
#
#
#	var score_inst = JSON.new()
#	var f = FileAccess.open(scores_path, FileAccess.WRITE)
#	print(f.get_var())
#	var score_string = JSON.stringify(f.get_var())
#	var score_error = score_inst.parse(score_string)
#	print(score_inst)
#	if !score_error:
#		for entry in score_inst.data:
#			print(entry.name+str(entry.score))


func save_score(open_file, entry):
	open_file.store_var(entry)

func exit_game():
	get_tree().quit()

func options():
	pass

func start_game():
	GameController.difficulty = spinBox.value
	print("starting new game at diffculty "+str(GameController.difficulty))
	GameController.musicSync = audioPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://Data/Scenes/PlayArea.tscn")
