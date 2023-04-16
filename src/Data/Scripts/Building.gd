extends Area2D
# Responsiblities:
#	Create Area2D to detect slimes 
#	Retrieve and logically organise a Tilemap


# Loads
@onready var map = $BaseMap
@onready var civilian_class = preload("res://Data/Scenes/Civilian.tscn")
# Civilian mgmt
var civilian_list = []
var civilian_max : int = 0


func _ready():
	GameController.building = self
	create_building(GameController.difficulty)
	
func _physics_process(_delta):
	for body in get_overlapping_bodies():
		if body.has_method("hit_building"): 
			var nearest = null
			for civs in civilian_list:
				if nearest == null || body.global_position.distance_to(civs.global_position) < nearest:
					nearest = civs.global_position.distance_to(body.global_position)
				
			
			if nearest: 
				body.hit_building(nearest)
				print(nearest)



# Make a building from the tilemap's contents.
# ASSUMPTION: the building's origin.y = 16px off the ground
func create_building(d): 
#	Determine height and width
	var buildingHeight : int = clamp(ceil(d/2), 2, 99) # Every 4 difficulty points, the height goes up 2 levels
	buildingHeight = buildingHeight + (buildingHeight%2) # guarentee an even result
	var buildingWidth : int = clamp(ceil(d/2), 2, 4) 
	buildingWidth = buildingWidth - (buildingWidth%2) # guarentee an even result
	
	print("width: "+str(buildingWidth)+", height: "+str(buildingHeight))
	
#	Reminder: layer 2 is theBuilding in our tilemap.
#	base:
	map.set_cell(2, Vector2i(3*-floor(buildingWidth/2)-1, 0), 0, Vector2i(0,3)) # left edge
	map.set_cell(2, Vector2i(3*floor(buildingWidth/2) , 0), 0, Vector2i(2,3)) # right edge
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
				
#				Window
				if k==1:
					if randf() < .25:
						var inst_civilian = civilian_class.instantiate()
						civilian_max += 1
						inst_civilian.set_global_position(map.map_to_local(Vector2i(startingPosX,startingPosY+k)) + transform.origin)
						inst_civilian.set_collision_layer_value(5, true)
						inst_civilian._parent = self
						civilian_list += [inst_civilian]
						get_parent().add_child.call_deferred(inst_civilian)
						
						
						map.set_cell(3, Vector2i(startingPosX+1,startingPosY+k), 0, Vector2i(1,4))
					else:
						map.set_cell(3, Vector2i(startingPosX+1,startingPosY+k), 0, Vector2i(0,4))
				
				map.set_cell(2, Vector2i(startingPosX+2,startingPosY+k), 0, Vector2i(1,1))
		for k in 3:
			map.set_cell(2, Vector2i(3*-floor(buildingWidth/2), startingPosY+k), 0, Vector2i(0,1)) # left edge
			map.set_cell(2, Vector2i(3*floor(buildingWidth/2)-1 , startingPosY+k), 0, Vector2i(2,1)) # right edge
#	roof
	for i in buildingWidth: # cap off the building
		var startingPosX = (i-floor(buildingWidth/2))*3
		map.set_cell(2, Vector2i(startingPosX,  -(buildingHeight*3)-1), 0, Vector2i(1,0))
		map.set_cell(2, Vector2i(startingPosX+1,-(buildingHeight*3)-1), 0, Vector2i(1,0))
		map.set_cell(2, Vector2i(startingPosX+2,-(buildingHeight*3)-1), 0, Vector2i(1,0))
	map.set_cell(2, Vector2i(3*-floor(buildingWidth/2), -(buildingHeight*3)-1), 0, Vector2i(0,0)) # left edge
	map.set_cell(2, Vector2i(3*floor(buildingWidth/2)-1 , -(buildingHeight*3)-1), 0, Vector2i(2,0)) # right edge
#	Create collision shape based on width/height
	var shape_width = ((buildingWidth * 3)) * 32
	var shape_height = ((buildingHeight * 3) * 32)*2
	$CollisionShape2D.set_shape(RectangleShape2D.new())
	$CollisionShape2D.shape.size = Vector2(shape_width,shape_height)
	#	Guard clause: empty level
	if civilian_list == []:
		print("Reloading, empty civilian_list (guard triggered)")
		reload_building()

func reload_building():
	map.clear() 									# Clear the tilemap
	get_tree().call_group("Civilian","rescue",0) 	# Remove civilians
	civilian_list = []								# Empty list
	civilian_max = 0
	create_building(GameController.difficulty)		# Recreate building
