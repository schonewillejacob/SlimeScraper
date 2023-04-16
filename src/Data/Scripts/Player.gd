extends CharacterBody2D



# Viewport Wrapping
@export var camera_path : NodePath
@onready var camera = get_node(camera_path)
@onready var wrap_width = (get_viewport_rect().size.x / 2) + 32 # This value is equal to the width of the player.
@onready var wrap_xpos = camera.get_global_position().x
# Movement
const SPEED : float = 250.0
const JUMP_HEIGHT : float = -475.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
# Inputs
var x_axis : float
var jump : bool
# State Machine enumerator
enum States {
	Idle,
	Ladder,
	Jump,
	Run,
	Recovering
}
var state = States.Idle



func _process(_delta):
	process_ui()

func _physics_process(delta):
#	Movement
	process_movement(delta)
	wrap_around(wrap_xpos - wrap_width, wrap_xpos + wrap_width)
#	Colliding
	var slide_count = get_slide_collision_count()
	if slide_count:
		process_collision(slide_count)



func bounce():
	velocity.y = JUMP_HEIGHT * 1.5

func bounce_direction(hit_direction : Vector2):
	velocity = (-JUMP_HEIGHT) * hit_direction.normalized()

func process_ui():
#	Menuing
	if(Input.is_action_just_pressed("user_decline")):
		get_tree().change_scene_to_file("res://Data/Main.tscn")
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
#	Guard against bad state
	if state == States.Recovering: return
#	Iterate through to find enemies
	for i in range(slide_count):
		var slide_collider = get_slide_collision(i).get_collider()
#		Check for hitting an enemy.
		if slide_collider.is_in_group("Enemy"): 
			if (slide_collider.get_global_position().y - get_global_position().y) > 0:
				bounce()
				slide_collider.die()
			else:
				$recovery_timer.start()
				$Sprite2D.modulate = Color(1,.5,.5)
				state = States.Recovering
				bounce_direction(Vector2( sign(get_global_position().x - slide_collider.get_global_position().x), -1))#left or right?	
				slide_collider.apply_impulse(Vector2(randfn(0.0,1.0), -300))

func recovery_timeout():
	$Sprite2D.modulate = Color(1,1,1)
	state = States.Idle

func wrap_around(left : int, right : int):
	if get_global_position().x > right:
		set_position(Vector2(left, get_global_position().y)) 
	elif get_global_position().x < left:
		set_position(Vector2(right, get_global_position().y))
