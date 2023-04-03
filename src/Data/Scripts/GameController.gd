# This object coordinates the game, and holds the diffculty data & alogrithms associated with it.
# It's Autoloaded, and needs "space to breathe"
extends Node

var difficulty : int = 1
var player : CharacterBody2D
var building : Area2D

func _ready():
	randomize()
