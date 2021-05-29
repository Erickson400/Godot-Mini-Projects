extends KinematicBody

var speed = 39
var New_lerped_direction = Vector3.ZERO

var gravity = 0.5
var jump_force = 50
var Vspeed = 0

func _physics_process(delta):
	
	# Direction & smooth
	var direction:Vector3
	direction.x = Input.get_action_strength("ui_right") -  Input.get_action_strength("ui_left")
	direction.z =  Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up")
	
	direction = direction.normalized()
	New_lerped_direction = New_lerped_direction.linear_interpolate(direction, 0.1)
	
	# Jump
	var Jumping = false
	if is_on_floor():
		Vspeed = gravity
		if Input.is_action_just_pressed("ui_select"):
			Jumping = true
			Vspeed = -jump_force
	else:
		Vspeed += gravity
	
	# Move
	var Vspeed_vector = Vector3(0, -Vspeed, 0)
	var capsule_height = $CollisionShape.shape.height/2 + 0.2
	if Jumping:
		capsule_height = 0
	
	move_and_slide_with_snap((New_lerped_direction*speed)+Vspeed_vector
					,Vector3(0, -capsule_height,0)
					,Vector3.UP
					,true
					,4
					,deg2rad(50))








