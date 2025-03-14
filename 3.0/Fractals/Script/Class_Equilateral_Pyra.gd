extends Spatial

var mainMat_mat = preload("res://Assets/Green.tres")

const TRI_Cords = [
	Vector3(0,0,0),
	Vector3(1,0,0),
	Vector3(0.5,0,-1),
	Vector3(0.5,1,-0.5)
]

var mesh_array:ArrayMesh
var Mesh_Instance:MeshInstance
var vertices:PoolVector3Array
var normals:PoolVector3Array

var powered_size = 1

func _init(iterations:int, Size:float):
	mesh_array = ArrayMesh.new()
	Mesh_Instance = MeshInstance.new()
	Mesh_Instance.mesh = mesh_array
	add_child(Mesh_Instance)
	
	# Iterate and Multiply the pyramids
	powered_size = Size
	Make_Pyramid(Vector3(0,0,0), Size*2) # Make pyra_0
	for n in iterations:
		powered_size*=2
		Iterate(powered_size)
	print("Pyramids Loaded: ", vertices.size()/18)
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	
	mesh_array.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_array.surface_set_material(0, mainMat_mat)

func Iterate(Size:float):
	# Duplicate, makes pyras 1-3
	var Pyra_1 = vertices 
	var Pyra_2 = vertices
	var Pyra_3 = vertices
	var Pyra_norms = normals
	
	# Move the vertices
	for i in Pyra_1.size():
		Pyra_1[i] += Vector3(Size, 0, 0)
	for i in Pyra_2.size():
		Pyra_2[i] += Vector3(Size/2, 0, -Size)
	for i in Pyra_3.size():
		Pyra_3[i] += Vector3(Size/2, Size, -Size/2)
		
	# Use threads to load the vertices and normals
	var vertex_thread = Thread.new()
	var normal_thread = Thread.new()
	var vertex_thread_userdata = [
		Pyra_1,
		Pyra_2,
		Pyra_3
	]
	vertex_thread.start(self, "Func_vertex_thread", vertex_thread_userdata, 1)
	normal_thread.start(self, "Func_normal_thread", Pyra_norms, 1)
	
	vertex_thread.wait_to_finish()
	normal_thread.wait_to_finish()

func Func_vertex_thread(vertex_thread_userdata):
	vertices.append_array(vertex_thread_userdata[0])
	vertices.append_array(vertex_thread_userdata[1])
	vertices.append_array(vertex_thread_userdata[2])
	
func Func_normal_thread(Pyra_norms):
	normals.append_array(Pyra_norms)
	normals.append_array(Pyra_norms)
	normals.append_array(Pyra_norms)

func Make_Pyramid(Offset:Vector3, Size):
	Make_Triangle(0, 1, 2, Offset, Size) # Bottom
	Make_Triangle(3, 1, 0, Offset, Size) # Front
	Make_Triangle(3, 2, 1, Offset, Size) # Right
	Make_Triangle(3, 0, 2, Offset, Size) # Left

func Make_Triangle(corner_1, corner_2, corner_3, Offset:Vector3, Size):
	vertices.push_back((TRI_Cords[corner_1]*Size)+Offset)
	vertices.push_back((TRI_Cords[corner_2]*Size)+Offset)
	vertices.push_back((TRI_Cords[corner_3]*Size)+Offset)
	
	# Get Face normal
	var middle_vertex = TRI_Cords[corner_1]
	var first_vertex = TRI_Cords[corner_2] - middle_vertex
	var second_vertex = TRI_Cords[corner_3] - middle_vertex

	var local_normal = first_vertex.cross(second_vertex)

	for n in 3:
		normals.push_back(local_normal*-1)










