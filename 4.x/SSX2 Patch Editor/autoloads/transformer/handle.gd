extends Node


var _initial_mouse_position := Vector2.ZERO
var _initial_distance_to_plane := 0.0 # Comp distance to plane
var _initial_projected_position := Vector2.ZERO # 2D position of Comp
var _initial_offset_to_mouse := Vector2.ZERO # Offset between the projected Comp and the mouse
var _initial_corner_transform: Transform3D = Transform3D()
var _initial_opp_handle_transform: Transform3D = Transform3D()

var _initial_opposite_handle_distance: float = 0
var _opposite_handle: Node3D = null
var _handle: Node3D = null
var _patch: Patch = null


func init_translate(control_point: Node3D, patch: Patch, parent_corner: Corner):
	_patch = patch
	_handle = control_point
	_opposite_handle = parent_corner.get_opposite(control_point.name)
	_initial_corner_transform = _handle.global_transform
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(_handle.global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position
	_initial_distance_to_plane = MainCamera.get_distance_from_camera_plane(_handle.global_position)
	_initial_opposite_handle_distance = _opposite_handle.global_position.distance_to(parent_corner.global_position)
	_initial_opp_handle_transform = _opposite_handle.global_transform


func run_translate():
	var mouse_position = get_viewport().get_mouse_position()
	var camera = MainCamera.get_camera()
	var offset = camera.project_position(mouse_position + _initial_offset_to_mouse, \
			_initial_distance_to_plane)
	_handle.global_position = offset 
	
	var corner = _handle.get_parent()
	var direction_to_center = (_handle.global_position - corner.global_position).normalized() 
	direction_to_center *= _initial_opposite_handle_distance
	_opposite_handle.global_position = -direction_to_center + corner.global_position
	
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func init_rotate(control_point: Node3D, patch: Patch, parent_corner: Corner):
	_patch = patch
	_handle = control_point
	_opposite_handle = parent_corner.get_opposite(control_point.name)
	_initial_corner_transform = _handle.global_transform
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(parent_corner.global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position
	_initial_opposite_handle_distance = _opposite_handle.global_position.distance_to(parent_corner.global_position)
	_initial_opp_handle_transform = _opposite_handle.global_transform


func run_rotate():
	var corner = _handle.get_parent()
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var angle = _initial_offset_to_mouse.angle_to(current_offset_to_mouse)
	_handle.global_transform = _initial_corner_transform.rotated(MainCamera.forward, angle)
	
	var direction_to_center = (_handle.global_position - corner.global_position).normalized() 
	direction_to_center *= _initial_opposite_handle_distance
	_opposite_handle.global_position = -direction_to_center + corner.global_position
	
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func init_scale(control_point: Node3D, patch: Patch, parent_corner: Corner):
	_patch = patch
	_handle = control_point
	_initial_corner_transform = _handle.global_transform
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(parent_corner.global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position


func run_scale():
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var new_size = current_offset_to_mouse.length() / _initial_offset_to_mouse.length() 
	_handle.global_transform = _initial_corner_transform.scaled(Vector3(new_size, new_size, new_size))
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()
	

func commit():
	MainCamera.enable_movement()
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func revert():
	_handle.global_transform = _initial_corner_transform
	_opposite_handle.global_transform = _initial_opp_handle_transform
	MainCamera.enable_movement()
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()
	
