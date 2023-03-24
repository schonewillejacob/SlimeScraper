extends Camera2D


@export var player_path : NodePath
@onready var player = get_node(player_path)

func _physics_process(_delta):
	transform.origin.y = player.transform.origin.y
