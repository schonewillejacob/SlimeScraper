extends Node2D

# This scene contains the main menu.


# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()


func start_game():
	print("starting new game...")
	get_tree().change_scene_to_file("res://Data/Scenes/PlayArea.tscn")
