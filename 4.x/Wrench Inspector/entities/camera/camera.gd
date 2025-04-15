extends Node3D

const SENSITIVITY = 0.4
const ZOOM_IN_RATE = 0.9
const ZOOM_OUT_RATE = 1.1
const ZOOM_MIN = 0.5
const ZOOM_MAX = 10
var zoom = 4

const FOCUS_SPEED = 0.1
var focus_pos = Vector3.ZERO

@onready var cam:Camera3D = $HPivot/VPivot/Camera3D
@onready var Hpivot:Node3D = $HPivot
@onready var Vpivot:Node3D = $HPivot/VPivot

func _ready():
	Bus.focus_camera.connect(func(p): focus_pos=p)
	
	cam.position.z = zoom
	Hpivot.rotate_y(deg_to_rad(45))
	Vpivot.rotate_x(deg_to_rad(-35))
	

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("Pan"):
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		if event.is_action_released("Pan"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event.is_action_pressed("Zoom_in"):
			zoom = clampf(zoom*ZOOM_IN_RATE, ZOOM_MIN, ZOOM_MAX) 
			cam.transform.origin.z = zoom
		if event.is_action_pressed("Zoom_out"):
			zoom = clampf(zoom*ZOOM_OUT_RATE, ZOOM_MIN, ZOOM_MAX) 
			cam.transform.origin.z = zoom
			
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
		Hpivot.rotate_y(deg_to_rad(event.relative.x * -SENSITIVITY))
		Vpivot.rotate_x(deg_to_rad(event.relative.y * -SENSITIVITY))
		Vpivot.rotation_degrees.x = clamp(Vpivot.rotation_degrees.x, -90, 90)

func _process(_delta):
	self.transform.origin = self.transform.origin.lerp(focus_pos, FOCUS_SPEED)


