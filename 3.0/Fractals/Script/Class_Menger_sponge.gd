extends Spatial

var mainMat_mat = preload("res://Assets/Blue.tres")

const CUBE_Edges = [
	Vector3(0,1,0),
	Vector3(1,1,0),
	Vector3(1,0,0),
	Vector3(0,0,0),
	Vector3(0,1,-1),
	Vector3(1,1,-1),
	Vector3(1,0,-1),
	Vector3(0,0,-1)
]

var mesh_array:ArrayMesh
var Mesh_Instance:MeshInstance
var vertices:PoolVector3Array
var normals:PoolVector3Array
var thread_one:Thread
var thread_two:Thread
var thread_one_args = []
var thread_two_args = []
	
var powered_size = 1

func _init(iterations:int, Size:float):
	mesh_array = ArrayMesh.new()
	Mesh_Instance = MeshInstance.new()
	Mesh_Instance.mesh = mesh_array
	add_child(Mesh_Instance)
	
	# Iterate and Multiply the pyramids
	thread_one = Thread.new()
	thread_two = Thread.new()

	powered_size = Size
	Make_Cube(Vector3(0,0,0), Size*3) # Make cube_0
	for n in iterations:
		powered_size*=3
		Iterate(powered_size)
		print("Loaded Cube Iteration: ", n)
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_NORMAL] = normals
	
	mesh_array.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_array.surface_set_material(0, mainMat_mat)

func Iterate(Size:float):
	# Duplicate, makes cubes
	var Cube_norms = normals
	var Cubes = [] # index 0 is actually 1
	for i in 20:
		Cubes.push_back(PoolVector3Array(vertices))
	
	# Move the vertices
	var Floor_3_duplicate = []
	
	#Floor 0
	thread_one_args = {
		Cubes = Cubes,
		Size = Size,
		Floor_3_duplicate = Floor_3_duplicate
	}
	thread_one.start(self, "Load_Floor_0", thread_one_args, 1)
	
	#Floor 1
	thread_two_args = {
		Cubes = Cubes,
		Size = Size
	}
	thread_two.start(self, "Load_Floor_1", thread_two_args, 1)
	
	#Floor 2
	Floor_3_duplicate = thread_one.wait_to_finish()
	thread_one_args = {
		Cubes = Cubes,
		Size = Size,
		Floor_3_duplicate = Floor_3_duplicate
	}
	thread_one.start(self, "Load_Floor_2", thread_one_args, 1)
	
	thread_one.wait_to_finish()
	thread_two.wait_to_finish()
	
	# Use threads to load the vertices and normals
	thread_one_args = Cubes
	thread_one.start(self, "Func_vertex_thread", thread_one_args, 1)
	thread_two.start(self, "Func_normal_thread", Cube_norms, 1)
	
	thread_one.wait_to_finish()
	thread_two.wait_to_finish()

func Load_Floor_0(args):
	for i in args.Cubes[1].size():
		args.Cubes[1][i] += Vector3(0, 0, -args.Size)
	for i in args.Cubes[2].size():
		args.Cubes[2][i] += Vector3(0, 0, -args.Size*2)
	for i in args.Cubes[3].size():
		args.Cubes[3][i] += Vector3(args.Size, 0, 0)
	for i in args.Cubes[4].size():
		args.Cubes[4][i] += Vector3(args.Size, 0, -args.Size*2)
	for i in args.Cubes[5].size():
		args.Cubes[5][i] += Vector3(args.Size*2, 0, 0)
	for i in args.Cubes[6].size():
		args.Cubes[6][i] += Vector3(args.Size*2, 0, -args.Size)
	for i in args.Cubes[7].size():
		args.Cubes[7][i] += Vector3(args.Size*2, 0, -args.Size*2)
	
	return [ # for later
		args.Cubes[0],
		args.Cubes[1],
		args.Cubes[2],
		args.Cubes[3],
		args.Cubes[4],
		args.Cubes[5],
		args.Cubes[6],
		args.Cubes[7]
	]

func Load_Floor_1(args):
	for i in args.Cubes[8].size():
		args.Cubes[8][i] += Vector3(0, args.Size, 0)
	for i in args.Cubes[9].size():
		args.Cubes[9][i] += Vector3(0, args.Size, -args.Size*2)
	for i in args.Cubes[10].size():
		args.Cubes[10][i] += Vector3(args.Size*2, args.Size, 0)
	for i in args.Cubes[11].size():
		args.Cubes[11][i] += Vector3(args.Size*2, args.Size, -args.Size*2)

func Load_Floor_2(args):
	for i in 8:
		args.Cubes[i+12] = args.Floor_3_duplicate[i]
		for n in args.Cubes[i+12].size():
			args.Cubes[i+12][n] += Vector3(0,args.Size*2,0)

func Func_vertex_thread(vertex_thread_userdata):
	for i in 20:
		vertices.append_array(vertex_thread_userdata[i])
	
func Func_normal_thread(Pyra_norms):
	for i in 20:
		normals.append_array(Pyra_norms)













func Make_Cube(Offset:Vector3, Size):
	Make_Quad(0, 1, 2, 3, Offset, Size)
	Make_Quad(1, 5, 6, 2, Offset, Size)
	Make_Quad(5, 4, 7, 6, Offset, Size)
	Make_Quad(4, 0, 3, 7, Offset, Size)
	Make_Quad(4, 5, 1, 0, Offset, Size)
	Make_Quad(3, 2, 6, 7, Offset, Size)

func Make_Quad(corner_1, corner_2, corner_3, corner_4, Offset:Vector3, Size):
	vertices.push_back((CUBE_Edges[corner_1]*Size)+Offset)
	vertices.push_back((CUBE_Edges[corner_2]*Size)+Offset)
	vertices.push_back((CUBE_Edges[corner_3]*Size)+Offset)
	
	vertices.push_back((CUBE_Edges[corner_3]*Size)+Offset)
	vertices.push_back((CUBE_Edges[corner_4]*Size)+Offset)
	vertices.push_back((CUBE_Edges[corner_1]*Size)+Offset)
	
	# Get Face normal
	var middle_vertex = CUBE_Edges[corner_1]
	var first_vertex = CUBE_Edges[corner_2] - middle_vertex
	var second_vertex = CUBE_Edges[corner_3] - middle_vertex

	var local_normal = first_vertex.cross(second_vertex)

	for n in 6:
		normals.push_back(local_normal*-1)



























