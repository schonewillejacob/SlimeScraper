extends CharacterBody2D



# Viewport Wrapping
@export var camera_path : NodePath
@onready var camera = get_node(camera_path)
@onready var wrap_width = (get_viewport_rect().size.x / 2) + 32 # This value is equal to the width of the player.
@onready var wrap_xpos = camera.transform.origin.x


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
	
	var slide_count = get_slide_collision_count()
	if slide_count:
		process_collision(slide_count)
	
	wrap_around(wrap_xpos - wrap_width, wrap_xpos + wrap_width)


func process_ui():
#	Menuing
	if(Input.is_action_just_pressed("user_decline")): get_tree().quit() #Quit out
	
#	Movement
	if state == States.Recovering: # Guards against movement if state isn't right
		return
	x_axis = Input.get_axis("user_left", "user_right")
	jump = bool(Input.is_action_just_pressed("user_up") && is_on_floor())


func process_movement(delta):
#	Gravity.
	velocity.y += GRAVITY * delta
#	Jumping.
	if jump and is_on_floor():
		state = States.Jump
		velocity.y = JUMP_HEIGHT
#	Lateral speed.
	if state != States.Recovering:
		velocity.x = x_axis * SPEED
#	Move
	move_and_slide()


func process_collision(slide_count):
	var enemy_list = get_tree().get_nodes_in_group("Enemy")
#	Check for hitting an enemy.
	for i in range(slide_count):
		var slide_collider = get_slide_collision(i).get_collider()
		
#		Guard Clauses.
		if state == States.Recovering: return
		if slide_collider not in enemy_list: 
			state = States.Idle
			return
		
#		Determine outcome.
		if (slide_collider.transform.origin.y - transform.origin.y) > 0:
			bounce()
			slide_collider.die()
		else:
			state = States.Recovering
			bounce_direction(Vector2( sign(slide_collider.transform.origin.x - transform.origin.x), -1))#left or right?	
			$recovery_timer.start()
			print("bounced")


func bounce():
	velocity.y = JUMP_HEIGHT * 1.5

func bounce_direction(hit_direction : Vector2):
	print((-JUMP_HEIGHT) * hit_direction.normalized())
	velocity = (-JUMP_HEIGHT) * hit_direction.normalized()

func wrap_around(left : int, right : int):
	if transform.origin.x > right:
		transform.origin.x = left
	elif transform.origin.x < left:
		transform.origin.x = right


func recovery_timeout():
	state = States.Idle
