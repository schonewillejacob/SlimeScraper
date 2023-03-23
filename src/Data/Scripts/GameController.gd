# This object coordinates the game, and holds the diffculty data & alogrithms associated with it.
extends Node

var Difficulty : int

func _ready():
	randomize()
