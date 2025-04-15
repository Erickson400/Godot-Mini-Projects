extends Node


const MIN_ZOOM = 1
const MAX_ZOOM = 20
const ZOOM_SPEED = 0.5
const ZOOM_LERP_WEIGHT = 10
const ROTATION_SENSITIVITY = Vector2(0.01, 0.01)

var movable := true
var forward := Vector3.ZERO

var _zoom := 3.0
var _dragging := false
var _orbit_rotation := Vector2.ZERO

@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var pivot: Node3D = $CameraPivot


func _ready():
	camera.position.z = _zoom
	_orbit_rotation = Vector2(deg_to_rad(45), deg_to_rad(45))
	pivot.quaternion = Quaternion(Vector3.UP, - deg_to_rad(45)) * Quaternion()
	pivot.quaternion = Quaternion(pivot.basis.x, -deg_to_rad(45)) * pivot.quaternion


func _unhandled_input(event: InputEvent) -> void:
	if not movable:
		return
		
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					_zoom = max(_zoom - ZOOM_SPEED, MIN_ZOOM)
				MOUSE_BUTTON_WHEEL_DOWN:
					_zoom = min(_zoom + ZOOM_SPEED, MAX_ZOOM)
				MOUSE_BUTTON_MIDDLE:
					_dragging = true
					Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		else:
			if event.button_index == MOUSE_BUTTON_MIDDLE:
				_dragging = false
				Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	if event is InputEventMouseMotion:
		if _dragging:
			_orbit_rotation.y += event.screen_relative.x * ROTATION_SENSITIVITY.x
			_orbit_rotation.x += event.screen_relative.y * ROTATION_SENSITIVITY.y
			_orbit_rotation.x = clampf(_orbit_rotation.x, -deg_to_rad(90), deg_to_rad(90))
		

func _process(delta: float) -> void:
	forward = -pivot.basis.z
	camera.position.z = lerpf(camera.position.z, _zoom, ZOOM_LERP_WEIGHT * delta)
	pivot.quaternion = Quaternion(Vector3.UP, - _orbit_rotation.y) * Quaternion()
	pivot.quaternion = Quaternion(pivot.basis.x, - _orbit_rotation.x) * pivot.quaternion
	

##-----Public-----
func get_distance_from_camera_plane(global_point: Vector3) -> float:
	return (-camera.basis.z).dot(camera.to_local(global_point))


func get_camera() -> Camera3D:
	return camera
	

func get_pivot() -> Node3D:
	return pivot


func enable_movement() -> void:
	movable = true


func disable_movement() -> void:
	movable = false
