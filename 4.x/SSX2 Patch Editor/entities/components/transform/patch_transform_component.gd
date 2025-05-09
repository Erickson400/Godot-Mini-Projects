class_name PatchTransformComponent
extends TransformComponent


var _initial_mouse_position := Vector2.ZERO
var _initial_distance_to_near_plane := 0.0 # Comp distance to plane
var _initial_projected_position := Vector2.ZERO # 2D position of Comp
var _initial_offset_to_mouse := Vector2.ZERO # Offset between the projected Comp and the mouse


func _ready() -> void:
	can_translate = true
	can_rotate = true
	can_scale = true


func _init_translate():
	global_position = Vector3.ZERO
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position
	_initial_distance_to_near_plane = -camera.get_frustum()[0].distance_to(global_position)
	

func _run_translate():
	var mouse_position = get_viewport().get_mouse_position()
	global_position = camera.project_position(mouse_position + _initial_offset_to_mouse, \
			_initial_distance_to_near_plane + camera.near)
	var offset = global_position
	for i in nodes_to_transform.size():
		nodes_to_transform[i].global_position = _initial_node_positions[i] + offset


func _init_scale():
	global_position = _get_point_average()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position


func _run_scale():
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var new_size = current_offset_to_mouse.length() / _initial_offset_to_mouse.length() 
	for i in nodes_to_transform.size():
		var centered_position = _initial_node_positions[i] - global_position
		var resized_position = centered_position * new_size
		var restored_position = resized_position + global_position
		nodes_to_transform[i].global_position = restored_position


func _init_rotate():
	global_position = _get_point_average()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position


func _run_rotate():
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var angle = current_offset_to_mouse.angle_to(_initial_offset_to_mouse)
	for i in nodes_to_transform.size():
		var centered_position = _initial_node_positions[i] - global_position
		var rotated_position = centered_position.rotated(camera.global_basis.z, angle)
		var restored_position = rotated_position + global_position
		nodes_to_transform[i].global_position = restored_position
	
	
func _get_point_average() -> Vector3:
	var average := Vector3.ZERO
	for node in nodes_to_transform:
		average += node.global_position
	return average / nodes_to_transform.size()
