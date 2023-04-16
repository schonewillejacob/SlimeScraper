extends AudioStreamPlayer



@onready var main_track = preload("res://Assets/Audio/Slime.mp3")



func restart_loop():
	stream = main_track
	play()
