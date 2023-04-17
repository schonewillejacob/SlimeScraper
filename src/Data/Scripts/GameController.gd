# This object coordinates the game, and holds the diffculty data & alogrithms associated with it.
# It's Autoloaded, and needs "space to breathe"
extends Node

# Stored data
var difficulty : int = 1
var score : int = 0
var health : int = 3
var civilians_rescued : = 0
var civilians_total : = 0

# Stored references
var player : CharacterBody2D
var building : Area2D
var musicSync


func _ready():
	randomize()

func check_game():
	if health < 1:
		print("Game over")
	elif building.civilian_list != []:
		print("Civs present")
	else:
		print("health good, no civs")
