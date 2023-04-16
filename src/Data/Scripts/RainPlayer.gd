extends AudioStreamPlayer2D



@onready var main_track = preload("res://Assets/Audio/rain.wav")
@export var TARGET_VOLUME = 1.2

var flag_volumeUp : bool = true;
var counter = 0

func _process(delta):
	if (flag_volumeUp):
		volume_db += 0.005*counter
		counter += .1
	# Clamp to a) constrain to lower limit for conditional and b) get the desired outcome.
	volume_db = clamp(volume_db, TARGET_VOLUME, 99)
	if volume_db-TARGET_VOLUME == 0.0: flag_volumeUp = false

func restart_loop():
	stream = main_track
	play()
