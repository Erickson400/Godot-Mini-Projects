extends Spatial

# Steering Constants
const STEER_FORCE = 1
const COUNTER_STEER_FORCE = 5
const MAX_STEER_ANGLE = deg2rad(30)

# Engine Constants
var ENGINE_POWER = 60



func _physics_process(_delta):
	var steer_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	steer(steer_strength)
	
	var gas = 0
	var sensitivity = 1000
	if Input.is_action_pressed("ui_up"):
		gas = sensitivity
	elif Input.is_action_pressed("ui_down"):
		gas = -sensitivity
	else:
		gas = 0
		
	var current_velocity = $BRJoint.get_param_y(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY)
	var final = gas
	
	$BRJoint.set_param_x(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_FORCE_LIMIT, final)
	$BLJoint.set_param_x(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_FORCE_LIMIT, final)



func accelerate():
	pass


func steer(amount):
	if amount < 0.1 and  amount > -0.1:
		# Counter steer if amount is close to zero
		var basis1 = -$Body.global_transform.basis.x
		var basis2 = -$FLWheel.global_transform.basis.x
		var target_vel = basis1.cross(basis2).y * COUNTER_STEER_FORCE
		$FLJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, target_vel)
		$FRJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, target_vel)
	else:
		# Steer by moving the wheels
		$FLJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, amount * STEER_FORCE)
		$FRJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, amount * STEER_FORCE)






