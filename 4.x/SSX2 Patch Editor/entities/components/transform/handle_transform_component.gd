class_name HandleTransformComponent
extends TransformComponent


@export var opposite_handle: Node3D = null

var _initial_mouse_position := Vector2.ZERO
var _initial_distance_to_near_plane := 0.0 # Comp distance to plane
var _initial_projected_position := Vector2.ZERO # 2D position of Comp
var _initial_offset_to_mouse := Vector2.ZERO # Offset between the projected Comp and the mouse
var _initial_opposite_handle_size := 0.0

@onready var center: Bubble = $"../../../Center"


func _ready():
	can_translate = true
	can_rotate = false
	can_scale = false


func _init_translate():
	_initial_mouse_position = get_viewport().get_mouse_position()
	_initial_projected_position = camera.unproject_position(global_position)
	_initial_offset_to_mouse = _initial_projected_position - _initial_mouse_position
	_initial_distance_to_near_plane = -camera.get_frustum()[0].distance_to(global_position)
	_initial_opposite_handle_size = opposite_handle.global_position.distance_to(center.global_position)


func _run_translate():
	var mouse_position = get_viewport().get_mouse_position()
	
	nodes_to_transform[0].global_position = camera.project_position(mouse_position + _initial_offset_to_mouse, \
			_initial_distance_to_near_plane + camera.near)

	if opposite_handle:
		var this_handle = get_parent()
		var direction_to_center = (this_handle.global_position - center.global_position).normalized() 
		direction_to_center *= _initial_opposite_handle_size
		opposite_handle.global_position = -direction_to_center + center.global_position
		
