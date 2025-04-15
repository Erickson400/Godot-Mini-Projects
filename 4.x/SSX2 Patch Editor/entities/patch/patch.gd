class_name Patch
extends MeshInstance3D


const SELECT_COLOR: Color = Color.MAGENTA

@export_category("Corners")
@export var left_front: Corner = null
@export var right_front: Corner = null
@export var left_back: Corner = null
@export var right_back: Corner = null
@export_category("Surrounding Patches")
@export var surrounding_patches: Array[Patch] = []


func _ready() -> void:
	var error_message = "Patch does not have all corners"
	assert(left_front and right_front and left_back and right_back, error_message)
	update_mesh()


func _evaluate_bezier_surface(control_points: Array[Vector3], u:float, v:float) -> Vector3:
	# Compute 4 control points along the u direction
	var u_points: Array[Vector3] = []
	for i in 4:
		var curve_points: Array[Vector3] = []
		curve_points.resize(4)
		curve_points[0] = control_points[i*4]
		curve_points[1] = control_points[i*4 + 1]
		curve_points[2] = control_points[i*4 + 2]
		curve_points[3] = control_points[i*4 + 3]
		var point = curve_points[0].bezier_interpolate(curve_points[1], curve_points[2], curve_points[3], u)
		u_points.append(point)
	
	# Compute the final position on the surface using v
	return u_points[0].bezier_interpolate(u_points[1], u_points[2], u_points[3], v)


func update_mesh():
	var get_outer_point: Callable = func(corner: Corner, handle_a: String, handle_b: String) -> Vector3:
		return corner.to_global(corner.handle[handle_a].position + corner.handle[handle_b].position)
		
	# Get control points:
	var control_points: Array[Vector3] = [
		left_front.global_position,
		left_front.handle["+X"].global_position,
		right_front.handle["-X"].global_position,
		right_front.global_position,
		
		left_front.handle["+Z"].global_position,
		get_outer_point.call(left_front, "+X", "+Z"),
		get_outer_point.call(right_front, "-X", "+Z"),
		right_front.handle["+Z"].global_position,
		
		left_back.handle["-Z"].global_position,
		get_outer_point.call(left_back, "+X", "-Z"),
		get_outer_point.call(right_back, "-X", "-Z"),
		right_back.handle["-Z"].global_position,
		
		left_back.global_position,
		left_back.handle["+X"].global_position,
		right_back.handle["-X"].global_position,
		right_back.global_position,
	]

	# Generate tesselated mesh
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in 7:
		for x in 7:
			var p = Vector2(x/7.0, z/7.0)
			surface.set_smooth_group(-1)
			surface.set_uv(p)
			surface.add_vertex(_evaluate_bezier_surface(control_points, p.x, p.y))
			p = Vector2((x+1)/7.0, z/7.0)
			surface.set_uv(p)
			surface.add_vertex(_evaluate_bezier_surface(control_points, p.x, p.y))
			p = Vector2((x+1)/7.0, (z+1)/7.0)
			surface.set_uv(p)
			surface.add_vertex(_evaluate_bezier_surface(control_points, p.x, p.y))
			p = Vector2(x/7.0, z/7.0)
			surface.set_uv(p)
			surface.add_vertex(_evaluate_bezier_surface(control_points, p.x, p.y))
			p = Vector2((x+1)/7.0, (z+1)/7.0)
			surface.set_uv(p)
			surface.add_vertex(_evaluate_bezier_surface(control_points, p.x, p.y))
			p = Vector2(x/7.0, (z+1)/7.0)
			surface.set_uv(p)
			surface.add_vertex(_evaluate_bezier_surface(control_points, p.x, p.y))
			
	surface.generate_normals()
	mesh = surface.commit()
	ModeManager.add_mesh_to_select_buffer(self, mesh)


func update_mesh_on_surrounding_patches():
	for patch in surrounding_patches:
		patch.update_mesh()


func get_corners() -> Array[Corner]:
	return [
		left_front,
		right_front,
		left_back,
		right_back,
	]


func enable_select_hue() -> void:
	material_override.albedo_color = SELECT_COLOR


func disable_select_hue() -> void:
	material_override.albedo_color = Color.WHITE
