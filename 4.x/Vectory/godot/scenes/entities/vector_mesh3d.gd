@tool
class_name VectorMesh3D extends MeshInstance3D


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
			vertices.append(Vector3(float(split[1]), float(split[2]), float(split[3])))
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
	material_override = StandardMaterial3D.new()
	material_override.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material_override.vertex_color_use_as_albedo = true
	material_override.albedo_color = Color.GREEN
	
	
	
	
	









