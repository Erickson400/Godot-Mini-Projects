extends Node


var _initial_mouse_position := Vector2.ZERO
var _initial_distance_to_plane := 0.0 # Comp distance to plane
var _initial_projected_position := Vector2.ZERO # 2D position of Comp
var _initial_offset_to_mouse := Vector2.ZERO # Offset between the projected Comp and the mouse
var _initial_point_average := Vector3.ZERO
var _initial_corner_transform: Array[Transform3D] = []
var _patch: Patch = null
var _corners: Array[Corner] = []


func init_translate(patch: Patch):
	_patch = patch
	_corners = patch.get_corners()
	_initial_corner_transform.clear()
	for corner in _corners:
		_initial_corner_transform.append(corner.global_transform)
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	var point_average: Vector3 = _get_point_average()
	_initial_point_average = point_average
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(point_average)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position
	_initial_distance_to_plane = MainCamera.get_distance_from_camera_plane(point_average)
	

func run_translate():
	var mouse_position = get_viewport().get_mouse_position()
	var camera = MainCamera.get_camera()
	var offset = camera.project_position(mouse_position + _initial_offset_to_mouse, \
			_initial_distance_to_plane)
	offset -= _initial_point_average
	for i in _corners.size():
		_corners[i].global_position = _initial_corner_transform[i].origin + offset 
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func init_rotate(patch: Patch):
	_patch = patch
	_corners = patch.get_corners()
	_initial_corner_transform.clear()
	for corner in _corners:
		_initial_corner_transform.append(corner.global_transform)
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	var point_average: Vector3 = _get_point_average()
	_initial_point_average = point_average
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(_get_point_average())
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position


func run_rotate():
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var angle = _initial_offset_to_mouse.angle_to(current_offset_to_mouse)
	for i in _corners.size():
		var centered_position = _initial_corner_transform[i].origin - _initial_point_average
		var rotated_position = centered_position.rotated(MainCamera.forward, angle)
		var restored_position = rotated_position + _initial_point_average
		_corners[i].global_transform = _initial_corner_transform[i].rotated(MainCamera.forward, angle)
		_corners[i].global_position = restored_position
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func init_scale(patch: Patch):
	_patch = patch
	_corners = patch.get_corners()
	_initial_corner_transform.clear()
	for corner in _corners:
		_initial_corner_transform.append(corner.global_transform)
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	var point_average: Vector3 = _get_point_average()
	_initial_point_average = point_average
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(point_average)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position


func run_scale():
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var new_size = current_offset_to_mouse.length() / _initial_offset_to_mouse.length() 
	for i in _corners.size():
		var centered_position = _initial_corner_transform[i].origin - _initial_point_average
		var resized_position = centered_position * new_size
		var restored_position = resized_position + _initial_point_average
		_corners[i].transform = _initial_corner_transform[i].scaled(Vector3(new_size, new_size, new_size))
		_corners[i].global_position = restored_position
		
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


## Gets the median of all corners. Handles are not included
func _get_point_average() -> Vector3:
	var average := Vector3.ZERO
	for corner in _corners:
		average += corner.global_position
	return average / 4.0
	

func commit():
	MainCamera.enable_movement()
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func revert():
	for i in _corners.size():
		_corners[i].global_transform = _initial_corner_transform[i]
		
	MainCamera.enable_movement()
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()
	
