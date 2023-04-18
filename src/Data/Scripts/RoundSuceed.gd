extends Control

func progress():
	GameController.difficulty += 2
	get_tree().change_scene_to_file("res://Data/Scenes/PlayArea.tscn")
