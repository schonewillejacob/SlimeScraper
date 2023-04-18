extends Area2D



var target : Vector2
@onready var sprite = $AnimatedSprite2D


func _ready():
	$check_for_death.start()	

func _process(delta):
	if sprite.animation == "die":
		if !sprite.is_playing():
			die()
	else:
		transform.origin += target

func check_on_building():
	if !has_overlapping_areas():
		sprite.set_animation("die")

func die():
	queue_free()
