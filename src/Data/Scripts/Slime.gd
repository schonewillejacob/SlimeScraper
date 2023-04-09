class_name Slime
extends RigidBody2D



const RAIN_DIRECTION := Vector2(-1.0, 1.0)
const STRENGTH : float = 16.0


var flagSpawned : bool = true
var flagJumping : bool = true

var debugcount = 0

# This is, by default, the midpoint of the screen.
@onready var target : Vector2 = Vector2(get_viewport_rect().size.x / 2, 0)

enum States {
	Spawned,
	Falling,
	Ground,
	Attached,
	Attacking
}
var state : States


func _init():
	apply_central_impulse(RAIN_DIRECTION * STRENGTH * 10)
	state = States.Falling

func _physics_process(_delta):
	process_movement()


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
				
#				Wait for 1.0s, then...
				await get_tree().create_timer(1.0).timeout
				var direction = STRENGTH*20 * Vector2(sign(target.x - transform.origin.x), -1)
				apply_central_impulse(direction)
				
#				Wait for 0.2s, then...
				await get_tree().create_timer(0.2).timeout
				state = States.Falling
				flagJumping = true
		States.Attached:
			pass


func die():
	queue_free()
	pass


func hit_building():
	set_collision_layer(4)
	state = States.Attached
