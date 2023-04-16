extends RigidBody2D
# Sprite credited to calciumtrice of opengameart
# https://opengameart.org/content/animated-slime


# loads
@onready var sprite = $sprite
# Movement
const RAIN_DIRECTION := Vector2(-1.0, 1.0)
const STRENGTH : float = 16.0
var flagSpawned : bool = true
var flagJumping : bool = true
# This is, by default, the midpoint of the screen.
@onready var target : Vector2 = Vector2(get_viewport_rect().size.x / 2, 0)
#State Machine 
enum States {
	Spawned,
	Falling,
	Ground,
	Attached
}
var state : States



func _init():
	apply_central_impulse(RAIN_DIRECTION * STRENGTH * 10)
	state = States.Falling

func _physics_process(_delta):
	process_movement()
	flip()



func process_movement():
	match (state):
		States.Falling: 
#			Just came from the cloud, should look ~45deg. due to speed.
			if flagSpawned: 
				apply_central_impulse(RAIN_DIRECTION * STRENGTH)
#			This runs when the creature stops against the ground.
			if linear_velocity.y < 0.01:
				if (abs(linear_velocity.x) < 1) || flagSpawned:
					if flagSpawned: flagSpawned = false
					state = States.Ground
			
		States.Ground:
#			Perform jump, change state, prevent multiple jump impulses w/ flag.
			if flagJumping:
				flagJumping = false
				
				await get_tree().create_timer(1.0).timeout # Wait for 1.0s, then...
				var direction = STRENGTH*20 * Vector2(sign(target.x - transform.origin.x), -1)
				apply_central_impulse(direction)
				
				await get_tree().create_timer(0.2).timeout # Wait for 0.2s, then...
				if state != States.Attached: 
					set_collision_layer_value(4, true)
				else: 
					flagJumping = true
					state = States.Falling
		States.Attached:
#			Move towards the target.
			pass

func die():
	queue_free()
	pass

func flip():
	if abs(sign(linear_velocity.x)) > 0.1:
		if sign(linear_velocity.x) > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true


func hit_building(nearest_civilian_direction):
#	Stop/Sleep/Remove building mask
	set_collision_layer_value(4, false)
#	target = nearest_civilian_direction
	state = States.Attached
	sleeping = true

func knocked_off():
	if is_sleeping(): 
		print("Knocked off!")
		state = States.Falling
