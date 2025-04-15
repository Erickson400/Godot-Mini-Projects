extends Node


var _initial_mouse_position := Vector2.ZERO
var _initial_distance_to_plane := 0.0 # Comp distance to plane
var _initial_projected_position := Vector2.ZERO # 2D position of Comp
var _initial_offset_to_mouse := Vector2.ZERO # Offset between the projected Comp and the mouse
var _initial_corner_transform: Transform3D = Transform3D()
var _corner: Node3D = null
var _patch: Patch = null


func init_translate(control_point: Node3D, patch: Patch):
	_patch = patch
	_corner = control_point
	_initial_corner_transform = _corner.global_transform
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(_corner.global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position
	_initial_distance_to_plane = MainCamera.get_distance_from_camera_plane(_corner.global_position)
	

func run_translate():
	var mouse_position = get_viewport().get_mouse_position()
	var camera = MainCamera.get_camera()
	var offset = camera.project_position(mouse_position + _initial_offset_to_mouse, \
			_initial_distance_to_plane)
	_corner.global_position = offset 
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func init_rotate(control_point: Node3D, patch: Patch):
	_patch = patch
	_corner = control_point
	_initial_corner_transform = _corner.global_transform
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(_corner.global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position


func run_rotate():
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var angle = _initial_offset_to_mouse.angle_to(current_offset_to_mouse)
	_corner.global_transform = _initial_corner_transform.rotated(MainCamera.forward, angle)
	_corner.global_position = _initial_corner_transform.origin
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func init_scale(control_point: Node3D, patch: Patch):
	_patch = patch
	_corner = control_point
	_initial_corner_transform = _corner.global_transform
	MainCamera.disable_movement()
	var camera = MainCamera.get_camera()
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(_corner.global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position


func run_scale():
	var mouse_position = get_viewport().get_mouse_position()
	var current_offset_to_mouse = _initial_projected_position - mouse_position
	var new_size = current_offset_to_mouse.length() / _initial_offset_to_mouse.length() 
	_corner.global_transform = _initial_corner_transform.scaled(Vector3(new_size, new_size, new_size))
	_corner.global_position = _initial_corner_transform.origin
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()
	

func commit():
	MainCamera.enable_movement()
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()


func revert():
	_corner.global_transform = _initial_corner_transform
	MainCamera.enable_movement()
	_patch.update_mesh()
	_patch.update_mesh_on_surrounding_patches()
	
