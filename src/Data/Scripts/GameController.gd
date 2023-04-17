# This object coordinates the game, and holds the diffculty data & alogrithms associated with it.
# It's Autoloaded, and needs "space to breathe"
extends Node
@onready var path_success : String = "res://Data/Scenes/menus/RoundSuceed.tscn"
@onready var path_fail : String = "res://Data/Scenes/menus/RoundFail.tscn"



# Stored data
var difficulty : int = 1
var score : int = 0
var civilians_rescued : = 0
var civilians_total : = 0

# Stored references
var player : CharacterBody2D
var building : Area2D
var musicSync


func _ready():
	randomize()

func check_game():
	if building.civilian_list == []:
		print("Round ending...")
		if float(civilians_rescued)/float(civilians_total) > 0.25:
			get_tree().change_scene_to_file(path_success)
		else:
			get_tree().change_scene_to_file(path_fail)
