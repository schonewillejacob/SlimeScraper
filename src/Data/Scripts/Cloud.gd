extends Node2D

@onready var sprite : Sprite2D = $sprite
@onready var spawn_attempt : Timer = $spawn_attempt
@onready var controller = $GameController
@onready var slime_class = preload("res://Data/Scenes/Slime.tscn")

@onready var wrap_width = (get_viewport_rect().size.x / 2) + 32 # This value is equal to the width of the player.
@onready var wrap_xpos = transform.origin.x

@onready var P = clamp(1 - (1/float(GameController.difficulty)), .25, 1 )

func _ready():
#	50/50 chance to flip xscale
	var chance = randi()%2
	if (chance):
		sprite.scale = Vector2(-1,1)
	spawn_attempt.start

func _process(_delta):
	transform.origin.x += 1
	wrap_around(wrap_xpos - wrap_width, wrap_xpos + wrap_width)

func spawn():
	spawn_attempt.start
	if randf() <= P:
		var slime_inst = slime_class.instantiate()
		slime_inst.transform.origin.x = transform.origin.x
		slime_inst.transform.origin.y = transform.origin.y
		get_parent().add_child(slime_inst)

func wrap_around(left : int, right : int):
	if transform.origin.x > right:
		transform.origin.x = left
	elif transform.origin.x < left:
		transform.origin.x = right
