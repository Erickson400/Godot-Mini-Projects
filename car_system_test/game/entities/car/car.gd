extends Spatial



const STEER_FORCE = 1
const MAX_STEER_ANGLE = deg2rad(30)

func _physics_process(_delta):
	var steer_strength = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	steer(steer_strength)

func steer(amount):
	if amount < 0.1 and  amount > -0.1:
		# Don't steer if amount is close to zero
		$FLJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_LOWER_LIMIT, 0)
		$FLJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_UPPER_LIMIT, 0)
		$FRJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_LOWER_LIMIT, 0)
		$FRJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_UPPER_LIMIT, 0)
		
	else:
		# Steer
		if amount > 0:
			# Increase Upper limit so it can move
			$FLJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_UPPER_LIMIT, MAX_STEER_ANGLE * amount)
			$FRJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_UPPER_LIMIT, MAX_STEER_ANGLE * amount)
		else:
			# Increase Lower limit so it can move
			$FLJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_LOWER_LIMIT, MAX_STEER_ANGLE * amount)
			$FRJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_LOWER_LIMIT, MAX_STEER_ANGLE * amount)
		
		# Move the wheels
		$FLJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, amount * STEER_FORCE)
		$FRJoint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, amount * STEER_FORCE)









