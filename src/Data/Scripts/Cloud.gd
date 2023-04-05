extends Node2D

@onready var sprite : Sprite2D = $sprite
@onready var spawnTimer : Timer = $spawn_another
@onready var controller = $GameController
@onready var slime_class = preload("res://Data/Scenes/Slime.tscn")

@onready var wrap_width = (get_viewport_rect().size.x / 2) + 32 # This value is equal to the width of the player.
@onready var wrap_xpos = transform.origin.x

func _ready():
#	50/50 chance to flip xscale
	var chance = randi()%2
	if (chance):
		sprite.scale = Vector2(-1,1)
	spawnTimer.start

func _process(_delta):
	transform.origin.x += 1
	wrap_around(wrap_xpos - wrap_width, wrap_xpos + wrap_width)

func spawn():
	spawnTimer.start
	add_child(slime_class.instantiate())

func wrap_around(left : int, right : int):
	if transform.origin.x > right:
		transform.origin.x = left
	elif transform.origin.x < left:
		transform.origin.x = right
