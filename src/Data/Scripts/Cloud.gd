extends Node2D

@onready var sprite : Sprite2D = $sprite
@onready var spawn_attempt : Timer = $spawn_attempt
@onready var slime_class = preload("res://Data/Scenes/Slime.tscn")

@onready var wrap_width = (get_viewport_rect().size.x / 2) + 32 # This value is equal to the width of the player.
@onready var wrap_xpos = transform.origin.x

@onready var P = clamp(1 - (1/float(GameController.difficulty)), .25, 1 )

var red_mod : float = 0

func _ready():
#	50/50 chance to flip xscale
	var chance = randi()%2
	if (chance):
		sprite.scale = Vector2(-1,1)
#	Begin timer
	spawn_attempt.start()
	
	
#	Set height
	var Height : int = clamp(ceil(GameController.difficulty/2), 2, 9999) # Every six difficulty points, the height goes up 2 levels
	Height = Height + (Height%2) # guarentee an even result
	set_position(Vector2(get_global_position().x + (randi()%400 - 200), 512 - ((Height+2)*96)))
	

func _process(_delta):
	transform.origin.x += 1
	wrap_around(wrap_xpos - wrap_width, wrap_xpos + wrap_width)
	red_mod = clamp(red_mod-0.001, .75, 1)
	sprite.modulate = Color(1, red_mod, 1)

func spawn():
	spawn_attempt.start()
	if randf() <= P:
		red_mod = 1
		var slime_inst = slime_class.instantiate()
		slime_inst.transform.origin.x = transform.origin.x
		slime_inst.transform.origin.y = transform.origin.y
		get_parent().add_child(slime_inst)

func wrap_around(left : int, right : int):
	if transform.origin.x > right:
		transform.origin.x = left
	elif transform.origin.x < left:
		transform.origin.x = right
