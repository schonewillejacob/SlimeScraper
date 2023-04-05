extends Node2D
# This scene contains the main menu.

var save_path = "user://highscore.save"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_score()




func load_score():
	if FileAccess.file_exists(save_path):
		var f = FileAccess.open(save_path, FileAccess.READ)
		var content = f.get_as_text()
		f.close()
