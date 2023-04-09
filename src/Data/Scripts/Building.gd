extends Area2D

@onready var map = $BaseMap



# Responsiblities:
#	Create Area2D to detect slimes 
#	Retrieve and logically organise a Tilemap


func _ready():
	GameController.building = self
	create_building(GameController.difficulty)
	

# Make a building from the tilemap's contents.
# ASSUMPTION: the building's origin.y = 16px off the ground
func create_building(d): 
#	Determine height and width
	var buildingHeight : int = clamp(ceil(d/2), 2, 9999) # Every six difficulty points, the height goes up 2 levels
	buildingHeight = buildingHeight + (buildingHeight%2) # guarentee an even result
	
	var buildingWidth : int = clamp(ceil(d/2), 2, 4) 
	buildingWidth = buildingWidth - (buildingWidth%2) # guarentee an even result
	
	print("width: "+str(buildingWidth))
	print("height: "+str(buildingHeight))
	
#	Reminder: layer 2 is theBuilding in our tilemap.

#	base:
	map.set_cell(2, Vector2i(3*-floor(buildingWidth/2)-1, 0), 0, Vector2i(0,3)) # left edge
	map.set_cell(2, Vector2i(3*floor(buildingWidth/2)   , 0), 0, Vector2i(1,3)) # right fill
	map.set_cell(2, Vector2i(3*floor(buildingWidth/2)+1 , 0), 0, Vector2i(2,3)) # right edge
	for i in buildingWidth: # 3x for spaces
		var startingPosX = (i-floor(buildingWidth/2))*3
		map.set_cell(2, Vector2i(startingPosX,0),   0, Vector2i(1,3))
		map.set_cell(2, Vector2i(startingPosX+1,0), 0, Vector2i(1,3))
		map.set_cell(2, Vector2i(startingPosX+2,0), 0, Vector2i(1,3))
	
#	walls
	for i in buildingHeight: #iterate through layers vertically.
		var startingPosY = (i-floor(buildingHeight))*3
		for j in buildingWidth: # 3x for spaces
			var startingPosX = (j-floor(buildingWidth/2))*3
			for k in 3:
				map.set_cell(2, Vector2i(startingPosX,startingPosY+k),   0, Vector2i(1,1))
				map.set_cell(2, Vector2i(startingPosX+1,startingPosY+k), 0, Vector2i(1,1))
				map.set_cell(2, Vector2i(startingPosX+2,startingPosY+k), 0, Vector2i(1,1))
		for k in 3:
			map.set_cell(2, Vector2i(3*-floor(buildingWidth/2), startingPosY+k), 0, Vector2i(0,1)) # left edge
			map.set_cell(2, Vector2i(3*floor(buildingWidth/2)-1   , startingPosY+k), 0, Vector2i(1,1)) # right fill
			map.set_cell(2, Vector2i(3*floor(buildingWidth/2) , startingPosY+k), 0, Vector2i(2,1)) # right edge
	
#	roof
	for i in buildingWidth: # cap off the building
		var startingPosX = (i-floor(buildingWidth/2))*3
		map.set_cell(2, Vector2i(startingPosX,  -(buildingHeight*3)-1), 0, Vector2i(1,0))
		map.set_cell(2, Vector2i(startingPosX+1,-(buildingHeight*3)-1), 0, Vector2i(1,0))
		map.set_cell(2, Vector2i(startingPosX+2,-(buildingHeight*3)-1), 0, Vector2i(1,0))
	map.set_cell(2, Vector2i(3*-floor(buildingWidth/2), -(buildingHeight*3)-1), 0, Vector2i(0,0)) # left edge
	map.set_cell(2, Vector2i(3*floor(buildingWidth/2) , -(buildingHeight*3)-1), 0, Vector2i(2,0)) # right edge
	
#	collision shape based on width/height
	var shape_width = ((buildingWidth * 3)+1) * 32
	var shape_height = ((buildingHeight * 3) * 32)*2
	
	$CollisionShape2D.set_shape(RectangleShape2D.new())
	$CollisionShape2D.shape.size = Vector2(shape_width,shape_height)
	

func reload_building():
	map.clear()
	create_building(GameController.difficulty)

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.has_method("hit_building"): body.hit_building()
