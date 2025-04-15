extends CharacterBody3D


const SPEED = 7
const ACCEL_GROUND = 7
const ACCEL_AIR = 1
const GRAVITY = 8
const JUMP_FORCE = 5
const CAMERA_ACCELERATION = 40
const MOUSE_SENSITIVITY = 0.4

@onready var acceleration = ACCEL_GROUND
@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _physics_process(delta):
	var input_strength = Vector3.ZERO
	input_strength.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	input_strength.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var h_rotation = global_rotation.y
	var direction = input_strength.rotated(Vector3.UP, h_rotation).normalized()
	
	var vertical_velocity = velocity.y
	if is_on_floor():
		acceleration = ACCEL_GROUND
		vertical_velocity = 0
	else:
		acceleration = ACCEL_AIR
		vertical_velocity -= GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vertical_velocity = JUMP_FORCE
	
	velocity = velocity.lerp(direction * SPEED, acceleration * delta)
	velocity.y = vertical_velocity
	
	move_and_slide()


