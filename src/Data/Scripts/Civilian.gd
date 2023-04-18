extends Area2D

# Loads
@onready var timer = $collide_timeout
@onready var sprite = $AnimatedSprite2D
var _parent
# Score
var awarded_score : int = 0
# Colours
var colours = {
	PINK = Color(242/255.0, 136/255.0, 159/255.0),
	GREEN = Color(50/255.0, 168/255.0, 82/255.0),
	BLUE = Color(2/255.0, 217/255.0, 245/255.0),
	PURPLE = Color(71/255.0, 2/255.0, 245/255.0),
}



func _ready():
#	Determine Civilian rarity
	var rarity = randi()%100
	if rarity < 64:
		sprite.modulate = colours.PINK
		awarded_score = 15
	elif rarity < 84:
		sprite.modulate = colours.GREEN
		awarded_score = 25
	elif rarity < 94:
		sprite.modulate = colours.BLUE
		awarded_score = 75
	elif rarity < 100:
		sprite.modulate = colours.PURPLE
		awarded_score = 150


func _physics_process(_delta):
	for body in get_overlapping_bodies():
#		Ignore if timer is running.
		if !timer.is_stopped(): return
#		Player collisions
		if body.is_in_group("Player"):
			body.bounce()
			set_collision_layer_value(5, false)
			timer.start()
			rescue(awarded_score)
#		Enemy Collisions
		if body.is_in_group("Enemy"):
			die()
	for area in get_overlapping_areas():
		if area.is_in_group("Enemy"):
			die()
	

func set_collision():
	set_collision_layer_value(5, true)

func remove():
	if _parent != null:
		_parent.civilian_list.erase(self)
		print(_parent.civilian_list)
	GameController.check_game()
	queue_free()

func die():
	GameController.score -= 15
	remove()

func rescue(points):
	GameController.score += points
	GameController.civilians_rescued += 1
	remove()
