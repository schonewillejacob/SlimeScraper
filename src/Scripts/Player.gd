extends CharacterBody2D


# Movement
const SPEED : float = 250.0
const JUMP_HEIGHT : float = -400
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

# State Machine
enum States {
	Idle,
	Ladder,
	Jump,
	Run
}
var state = States.Idle

func _physics_process(delta):
	print("On floor? " + str(is_on_floor())) 
	process_movement(delta)
	move_and_slide()


func process_movement(delta):
	velocity.y += GRAVITY * delta

	# Handle Jump.
	if Input.is_action_just_pressed("user_up") and is_on_floor():
		velocity.y = JUMP_HEIGHT

	# Get the input direction.
	var direction = Input.get_axis("user_left", "user_right")
	velocity.x = direction * SPEED



func alignToGrid():
	pass
