extends KinematicBody
 
export var speed = 10
export var acceleration = 5
export var gravity = 0.90
export var jump_power = 50
export var mouse_sensitivity = 0.3
 
onready var head = $Head
onready var camera = $Head/Camera
 
var mouseToggled = false
var velocity = Vector3()
var camera_x_rotation = 0
 
var damager_scn = preload("res://game/entities/damager/damager.tscn")
var rock_scn = preload("res://game/entities/rock/rock.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouseToggled = true
	#OS.set_window_fullscreen(true)
 
func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
 
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation  + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _process(delta):
	#print($Head/Camera/RayCast.get_collision_point())
	if Input.is_action_just_pressed("left_click"):
		
		var collider = $Head/Camera/RayCast.get_collider()
		if collider:
			if collider.is_in_group("wall"):
				var damager_inst = damager_scn.instance()
				collider.get_parent().combiner.add_child(damager_inst)
				damager_inst.global_transform.origin = $Head/Camera/RayCast.get_collision_point()
				
				var rock_inst = rock_scn.instance()
				collider.get_parent().combiner.add_child(rock_inst)
				rock_inst.global_transform.origin = $Head/Camera/RayCast.get_collision_point()
				





func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
 
	var direction = Vector3()
	if Input.is_action_pressed("ui_up"):
		direction -= head_basis.z
	elif Input.is_action_pressed("ui_down"):
		direction += head_basis.z
 
	if Input.is_action_pressed("ui_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("ui_right"):
		direction += head_basis.x
 
	direction = direction.normalized()
 
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
 
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y += jump_power
 
	move_and_slide(velocity, Vector3.UP)
	
