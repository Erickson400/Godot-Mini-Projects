extends MeshInstance2D
## Parent of point nodes and renders edges


var edges: Array = [] # index: ["p1", "p2"]
@onready var local_mesh := ImmediateMesh.new()


func _ready():
	mesh = local_mesh
	

func update_mesh():
	if edges.size() == 0:
		local_mesh.clear_surfaces()
		return
		
	local_mesh.clear_surfaces()
	local_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	local_mesh.surface_set_color(Color.GREEN)
	
	for i in edges.size():
		var point_a: Node2D = get_node("%s" % edges[i][0])
		var point_b: Node2D = get_node("%s" % edges[i][1])
		local_mesh.surface_add_vertex_2d(point_a.position)
		local_mesh.surface_add_vertex_2d(point_b.position)
	
	local_mesh.surface_end()
