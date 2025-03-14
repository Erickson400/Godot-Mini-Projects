extends Node

#====================Variables=====================
enum TILE_TYPE {
	INVINSIBLE = -1,
	BLACK,
	WHITE,
	GRAY,
	RED,
	GREEN,
	BLUE,
	ORANGE,
	YELLOW,
	PINK,
	PURPLE
}
var TileColors = [
	Color.white,
	Color.white,
	Color.gray,
	Color.red,
	Color.green,
	Color.blue
]
enum TILE_COMMANDS { # Axis arrow must point towards the camera
	YCLOCKWISE,
	YANTICLOCKWISE,
	XCLOCKWISE,
	XANTICLOCKWISE,
	ZCLOCKWISE,
	ZANTICLOCKWISE,
}
var ant = {
	position = Vector3.ZERO,
	direction = Vector3.FORWARD
}

#================Ant Functions==================

func Update():
	#Store color its on
	var on_color = get_tile()
	
	# Change color and
	# move depending on the color
	match on_color:
		TILE_TYPE.INVINSIBLE:
			set_tile(TILE_TYPE.BLACK)
			turn_ant(TILE_COMMANDS.YCLOCKWISE)
		TILE_TYPE.BLACK:
			set_tile(TILE_TYPE.INVINSIBLE)
			turn_ant(TILE_COMMANDS.YANTICLOCKWISE)
		TILE_TYPE.WHITE:
			set_tile(TILE_TYPE.GRAY)
			turn_ant(TILE_COMMANDS.YCLOCKWISE)
		TILE_TYPE.GRAY:
			set_tile(TILE_TYPE.RED)
			turn_ant(TILE_COMMANDS.YANTICLOCKWISE)
		TILE_TYPE.RED:
			set_tile(TILE_TYPE.GREEN)
			turn_ant(TILE_COMMANDS.YANTICLOCKWISE)
		TILE_TYPE.GREEN:
			set_tile(TILE_TYPE.BLUE)
			turn_ant(TILE_COMMANDS.YCLOCKWISE)
		TILE_TYPE.BLUE:
			set_tile(TILE_TYPE.INVINSIBLE)
			turn_ant(TILE_COMMANDS.YANTICLOCKWISE)
	
	ant.position += ant.direction
	
	
func turn_ant(command):
	match command:
		TILE_COMMANDS.YCLOCKWISE:
			ant.direction = ant.direction.rotated(Vector3.UP, -90).round()
		TILE_COMMANDS.YANTICLOCKWISE:
			ant.direction = ant.direction.rotated(Vector3.UP, 90).round()
		TILE_COMMANDS.XCLOCKWISE:
			ant.direction = ant.direction.rotated(Vector3.RIGHT, -90).round()
		TILE_COMMANDS.XANTICLOCKWISE:
			ant.direction = ant.direction.rotated(Vector3.RIGHT, 90).round()
		TILE_COMMANDS.ZCLOCKWISE:
			ant.direction = ant.direction.rotated(Vector3.FORWARD, -90).round()
		TILE_COMMANDS.ZANTICLOCKWISE:
			ant.direction = ant.direction.rotated(Vector3.FORWARD, 90).round()

func set_tile(color_enum):
	$GridMap.set_cell_item(ant.position.x, ant.position.y, ant.position.z, color_enum)
func get_tile():
	return $GridMap.get_cell_item(ant.position.x, ant.position.y, ant.position.z)

#====================Override Functions=====================
func _ready():
	## Setup Gridmap Mesh Library
	var mesh_library := MeshLibrary.new()
	
	for i in TileColors.size():
		var material := SpatialMaterial.new()
		material.albedo_color = TileColors[i]
		var mesh = CubeMesh.new()
		mesh.surface_set_material(0, material)
		mesh_library.create_item(i)
		mesh_library.set_item_mesh(i, mesh)
	$GridMap.mesh_library = mesh_library
	$GridMap.clear()
func _process(_delta):
	$fps.text = "FPS: %d" % Engine.get_frames_per_second()






func _on_Timer_timeout():
	for i in 40:
		Update()
