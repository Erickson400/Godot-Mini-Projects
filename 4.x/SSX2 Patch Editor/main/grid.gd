extends MeshInstance3D

const BIG_NUMBER = 0xFFF

@export var units = 1
@export var lines_per_side = 50
@export_range(0.1, 1) var alpha: float = 0.1


func _ready() -> void:
	var grid := SurfaceTool.new()
	grid.begin(Mesh.PRIMITIVE_LINES)
	grid.set_color(Color(1,1,1,alpha))
	# X
	var max_size = (lines_per_side + 1) * units
	for line in lines_per_side:
		line += 1
		grid.add_vertex(Vector3(line * units, 0, max_size))
		grid.add_vertex(Vector3(line * units, 0, -max_size))
		grid.add_vertex(Vector3(-line * units, 0, max_size))
		grid.add_vertex(Vector3(-line * units, 0, -max_size))
		
	# Z
	for line in lines_per_side:
		line += 1
		grid.add_vertex(Vector3(max_size, 0, line * units))
		grid.add_vertex(Vector3(-max_size, 0, line * units))
		grid.add_vertex(Vector3(max_size, 0, -line * units))
		grid.add_vertex(Vector3(-max_size, 0, -line * units))
		
	mesh = grid.commit()
	
