extends Spatial

const BIT_top = 0b000001
const BIT_bottom = 0b000010
const BIT_right = 0b000100
const BIT_left = 0b001000
const BIT_back = 0b010000
const BIT_front = 0b100000

var Mat_res = preload("res://Assets/BlockMat.material")

const Corners = [
	Vector3(-1,1,1),
	Vector3(1,1,1),
	Vector3(1,-1,1),
	Vector3(-1,-1,1),
	
	Vector3(-1,1,-1),
	Vector3(1,1,-1),
	Vector3(1,-1,-1),
	Vector3(-1,-1,-1),
]

var vertices = PoolVector3Array()
var UV_Cords = PoolVector3Array()
var Normals_Cords = PoolVector3Array()
var mesh:ArrayMesh

var Block_gridmap:GridMap
var Block_Side_gridmap:GridMap
var Mesh_Instance:MeshInstance


func _init(noise:OpenSimplexNoise, Offset=Vector2(0,0)):
	Block_gridmap = GridMap.new()
	Block_Side_gridmap = GridMap.new()
	mesh = ArrayMesh.new()
	Mesh_Instance = MeshInstance.new()
	Mesh_Instance.mesh = mesh
	add_child(Mesh_Instance)
	
	
	# Generate on Gridmap
	for z in 16:
		for x in 16:
			# Surface
			var xPos = x
			var zPos = z
			var yPos = round(noise.get_noise_2d(Offset.x+x,Offset.y+z)*20)
			Block_gridmap.set_cell_item(xPos, yPos, zPos, 1)
			
			# Underground
			for n in range(1, 4):
				Block_gridmap.set_cell_item(xPos, yPos-n, zPos, 1)
				
	
	# Check tile sides
	for tilepos in Block_gridmap.get_used_cells():
		var side_flag = 0
		
		if Block_gridmap.get_cell_item(tilepos.x, tilepos.y+1, tilepos.z) == 1 :
			side_flag |= BIT_top
		if Block_gridmap.get_cell_item(tilepos.x, tilepos.y-1, tilepos.z) == 1 :
			side_flag |= BIT_bottom
		if Block_gridmap.get_cell_item(tilepos.x+1, tilepos.y, tilepos.z) == 1 :
			side_flag |= BIT_right
		if Block_gridmap.get_cell_item(tilepos.x-1, tilepos.y, tilepos.z) == 1 :
			side_flag |= BIT_left
		if Block_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z-1) == 1 :
			side_flag |= BIT_back
		if Block_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z+1) == 1 :
			side_flag |= BIT_front
		
		Block_Side_gridmap.set_cell_item(tilepos.x, tilepos.y, tilepos.z, side_flag)
		
	generate_chunk_mesh()

func generate_chunk_mesh():
	# Make Quads here
	
	for tilepos in Block_gridmap.get_used_cells():
		
		var Tex_Type = { # Dirt by default
			top = Vector3(0,0,0),
			bottom = Vector3(2,0,0),
			front = Vector3(1,0,0),
			left = Vector3(1,0,0),
			right = Vector3(1,0,0),
			back = Vector3(1,0,0),
		}
		
		if tilepos.y < -1:
			Tex_Type.top = Vector3(3,0,0)
			Tex_Type.bottom = Vector3(3,0,0)
			Tex_Type.front = Vector3(3,0,0)
			Tex_Type.left = Vector3(3,0,0)
			Tex_Type.right = Vector3(3,0,0)
			Tex_Type.back = Vector3(3,0,0)
		
		
		
		if not Block_Side_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z) & BIT_top == BIT_top:
			Make_Quad(4,5,1,0, tilepos*2, Tex_Type.top) #top
		if not Block_Side_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z) & BIT_bottom== BIT_bottom:
			Make_Quad(3,2,6,7, tilepos*2, Tex_Type.bottom) #bottom
		if not Block_Side_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z) & BIT_front == BIT_front:
			Make_Quad(0,1,2,3, tilepos*2, Tex_Type.front) #front
		if not Block_Side_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z) & BIT_left == BIT_left:
			Make_Quad(4,0,3,7, tilepos*2, Tex_Type.left) #left
		if not Block_Side_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z) & BIT_right == BIT_right:
			Make_Quad(1,5,6,2, tilepos*2, Tex_Type.right) #right
		if not Block_Side_gridmap.get_cell_item(tilepos.x, tilepos.y, tilepos.z) & BIT_back == BIT_back:
			Make_Quad(5,4,7,6, tilepos*2, Tex_Type.back) #back
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arrays[ArrayMesh.ARRAY_TEX_UV] = UV_Cords
	arrays[ArrayMesh.ARRAY_NORMAL] = Normals_Cords
	
	# Create mesh
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh.surface_set_material(0, Mat_res)
	

func Make_Quad(corner_1:int, corner_2:int, corner_3:int, corner_4:int, Pos_Offset:Vector3 = Vector3(0,0,0), UV_offset:Vector3 = Vector3(0,0,0)):
	vertices.push_back(Corners[corner_1]+Pos_Offset)
	vertices.push_back(Corners[corner_2]+Pos_Offset)
	vertices.push_back(Corners[corner_3]+Pos_Offset)
	
	vertices.push_back(Corners[corner_3]+Pos_Offset)
	vertices.push_back(Corners[corner_4]+Pos_Offset)
	vertices.push_back(Corners[corner_1]+Pos_Offset)
	
	UV_Cords.push_back(Vector3(0, 0, 0)+UV_offset)
	UV_Cords.push_back(Vector3(1, 0, 0)+UV_offset)
	UV_Cords.push_back(Vector3(1, 1, 0)+UV_offset)
	
	UV_Cords.push_back(Vector3(1, 1, 0)+UV_offset)
	UV_Cords.push_back(Vector3(0, 1, 0)+UV_offset)
	UV_Cords.push_back(Vector3(0, 0, 0)+UV_offset)

	var top_left_corner = Vector3(0,0,0)
	var top_right_corner = Corners[corner_2] - Corners[corner_1]
	var bottom_right_corner = Corners[corner_4] - Corners[corner_1]

	var normal = top_right_corner.cross(bottom_right_corner)

	for n in 6:
		Normals_Cords.push_back(normal*-1)



