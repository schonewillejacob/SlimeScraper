extends Node2D

@onready var sprite : Sprite2D = $sprite
@onready var spawnTimer : Sprite2D = $spawn_another
@onready var controller = $GameController

var P : float
var 

func _ready():
#	50/50 chance to flip xscale
	var chance = randi()%2
	if (chance):
		sprite.scale = Vector2(-1,0)
	
	spawnTimer.start

func _physics_process(delta):
	
	pass

func spawn():
	spawnTimer.start
	
