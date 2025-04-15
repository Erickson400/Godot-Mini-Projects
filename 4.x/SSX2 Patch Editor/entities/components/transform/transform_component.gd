class_name TransformComponent
extends Node3D
## Base class for transform components


signal transformed

enum TransformMode {
	NONE,
	TRANSLATE,
	ROTATE,
	SCALE,
}

var can_translate: bool = false
var can_rotate: bool = false
var can_scale: bool = false
var nodes_to_transform: Array[Node3D] = []

var _enabled: bool = false
var _mode: int = TransformMode.NONE
var _initial_node_positions: Array[Vector3] = []

@onready var camera = get_viewport().get_camera_3d()


##-------Private--------
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _enabled:
		if _mode == TransformMode.TRANSLATE:
			_run_translate()
			transformed.emit()
		
		elif _mode == TransformMode.SCALE:
			_run_scale()
			transformed.emit()
			
		elif _mode == TransformMode.ROTATE:
			_run_rotate()
			transformed.emit()


func set_mode(mode: int) -> bool: # Returns weather the transform is possible
	if mode == TransformMode.TRANSLATE and not can_translate:
		return false
	if mode == TransformMode.ROTATE and not can_rotate:
		return false
	if mode == TransformMode.SCALE and not can_scale:
		return false
	
	MainCamera.disable_movement()
	_initial_node_positions.clear()
	for node in nodes_to_transform:
		_initial_node_positions.append(node.global_position)
	
	match mode:
		TransformMode.TRANSLATE:
			_init_translate()
			
		TransformMode.SCALE:
			_init_scale()
			
		TransformMode.ROTATE:
			_init_rotate()
			
	_mode = mode
	_enabled = true
	return true


##------Virtual----------
func _init_translate():
	pass


func _run_translate():
	pass
	
	
func _init_rotate():
	pass


func _run_rotate():
	pass
	
	
func _init_scale():
	pass


func _run_scale():
	pass


#---------Public---------
func commit() -> void:
	MainCamera.enable_movement()
	_mode = TransformMode.NONE
	_enabled = false
	transformed.emit()
	

func revert() -> void:
	MainCamera.enable_movement()
	for i in nodes_to_transform.size():
		nodes_to_transform[i].global_position = _initial_node_positions[i]
		
	_mode = TransformMode.NONE
	_enabled = false
	transformed.emit()
