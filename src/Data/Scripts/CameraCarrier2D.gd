extends Camera2D

var max_y = 250.0
@export var playerPath : NodePath
@onready var player = get_node(playerPath)


func _physics_process(delta):
	carry_to_player(delta)


func carry_to_player(_delta):
	var player_y : float = player.transform.origin.y
	transform.origin.y = clamp(player_y, player_y, max_y)
