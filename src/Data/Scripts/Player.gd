extends CharacterBody2D



# Movement
const SPEED : float = 250.0
const JUMP_HEIGHT : float = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

# Inputs
var x_axis : float
var jump : bool

# State Machine
enum States {
	Idle,
	Ladder,
	Jump,
	Run,
	Recovering
}
var state = States.Idle



func _physics_process(delta):
	process_ui()
	process_movement(delta)
	
	func process_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
#		print("I collided with ", collision.get_collider().name)


func process_ui():
	if state == States.Recovering:
		return
	
	x_axis = Input.get_axis("user_left", "user_right")
	jump = bool(Input.is_action_just_pressed("user_up") && is_on_floor())
	
#	Prevents input after being hit.
	



func process_movement(delta):
#	Gravity.
	velocity.y += GRAVITY * delta
#	Jumping.
	if Input.is_action_just_pressed("user_up") and is_on_floor():
			velocity.y = JUMP_HEIGHT * int(jump)
#	Lateral speed.
	velocity.x = x_axis * SPEED
#	Move
	move_and_slide()

func bounce(input : Vector2):
	velocity.bounce(input)

func process_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		var col_sign = sign(transform.orign.x - i.transform.origin.x)
		bounce(Vector2(col_sign * i.STRENGTH, -5))
