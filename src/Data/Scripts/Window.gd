extends Area2D

@onready var timer = $collide_timeout

# Check if window is occupied.
func _ready():
	pass


func _physics_process(delta):
#	ignore if timer is running
	if !timer.is_stopped(): return

	for body in get_overlapping_bodies():
		set_collision_layer_value(5, false)
		timer.start()
		
		print("Found: "+str(body))
		if body.has_method("bounce"): body.bounce()

func set_collision():
	set_collision_layer_value(5, true)
