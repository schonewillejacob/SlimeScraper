extends Area2D



# Responsiblities:
#	Create Area2D to detect slimes 
#	Retrieve and logically organise a Tilemap
#	Provide a Grid for alignment of ladders.

# Future:
#	Create Moss for slime growth
#	Asthetics via tilemap/code.


func _ready():
	GameController.building = self
	create_tilemap(GameController.difficulty)

# Make a building from the tilemap's contents.
func create_tilemap(d):
	print(d)
