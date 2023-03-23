extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_constant_central_force( Vector2(1.0,1.0) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
