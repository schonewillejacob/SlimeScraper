extends Area2D

@onready var map = $BaseMap
@onready var set = map.get_tileset()



# Responsiblities:
#	Create Area2D to detect slimes 
#	Retrieve and logically organise a Tilemap
#	Provide a Grid for alignment of ladders.


func _ready():
	GameController.building = self
	create_building(GameController.difficulty)

# Make a building from the tilemap's contents.
# ASSUMPTION: the building's origin.y = 16px off the ground
func create_building(d): 
#	Determine height and width
	var buildingHeight : int = clamp(ceil(d/6), 1, 9999) # Every six difficulty points, the height goes up a level
	var buildingWidth : int = clamp(ceil(d/2), 3, 7) 
#	Reminder: layer 2 is theBuilding in our tilemap.
	map.set_cell(2, Vector2i(0,1))

func reload_building():
	map.clear()
	create_building(GameController.difficulty)
