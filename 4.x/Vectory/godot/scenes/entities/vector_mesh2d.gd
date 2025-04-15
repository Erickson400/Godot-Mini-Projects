@tool
class_name VectorMesh2D extends MeshInstance2D


@export_file("*.obj") var obj_path: String


func _ready():
	var vertices: Array[Vector3] = []
	var edges: Array[Vector2i] = []
	
	if not FileAccess.file_exists(obj_path):
		push_error("Model path does not exist")
		return
		
	var file = FileAccess.open(obj_path, FileAccess.READ)
	while not file.eof_reached():
		var split = file.get_line().split(" ")
		
		if split[0] == "v":
			vertices.append(Vector3(-float(split[3]), -float(split[2]), 0))
		elif split[0] == "l":
			edges.append(Vector2i(int(split[1]), int(split[2])))
	
	
	var st: SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)
	st.set_color(Color.GREEN)
	
	for v in vertices:
		st.add_vertex(v)
	for e in edges:
		st.add_index(e[0]-1)
		st.add_index(e[1]-1)

	mesh = st.commit()
	
	# Material
	material = CanvasItemMaterial.new()
	material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	modulate = Color.GREEN
	
	
	
	
	
