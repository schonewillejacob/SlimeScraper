extends AudioStreamPlayer



@onready var main_track = preload("res://Assets/Audio/main.wav")
@export var TARGET_PITCH = 0.7

var flag_pitchDown : bool = true;
var counter = 0

func _process(delta):
	if (flag_pitchDown):
		pitch_scale -= 0.0005*counter
		counter += .1
	# Clamp to a) constrain to lower limit for conditional and b) get the desired outcome.
	pitch_scale = clamp(pitch_scale, TARGET_PITCH, 99)
	if pitch_scale-TARGET_PITCH == 0.0: flag_pitchDown = false

func restart_loop():
	stream = main_track
	play()
