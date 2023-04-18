extends GPUParticles2D


func _ready():
	#	Set height
	var Height : int = clamp(ceil(GameController.difficulty/2), 2, 9999) # Every six difficulty points, the height goes up 2 levels
	Height = Height + (Height%2) # guarentee an even result
	set_position(Vector2(270, (-(Height+2)*96)))
