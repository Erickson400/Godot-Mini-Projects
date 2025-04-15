extends MeshInstance3D

const SIZE = 0.1

@export var material: StandardMaterial3D
@export var handle_a: Node3D
@export var handle_b: Node3D


func _ready() -> void:
	var triangle := SurfaceTool.new()
	triangle.begin(Mesh.PRIMITIVE_TRIANGLES)
	triangle.add_vertex(Vector3(-0.7, 0, 0) * SIZE)
	triangle.add_vertex(Vector3(0, 1, 0) * SIZE)
	triangle.add_vertex(Vector3(0.7, 0, 0) * SIZE)
	
	triangle.add_vertex(Vector3(-0.7, 0, 0) * SIZE)
	triangle.add_vertex(Vector3(0.7, 0, 0) * SIZE)
	triangle.add_vertex(Vector3(0, -1, 0) * SIZE)
	
	mesh = triangle.commit()
	material_override = material


func update_position_to_handles():
	if handle_a and handle_b:
		position = handle_a.position + handle_b.position
	else:
		push_error("Control point has missing handles")
