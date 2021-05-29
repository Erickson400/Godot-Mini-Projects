extends State_Node



func physics_process(_delta):
	var steering_amount = 0
	
	# Input
	if Input.is_action_pressed("Left_Click") != Input.is_action_pressed("Right_Click"):
		if !Input.is_action_pressed("ui_left") && !Input.is_action_pressed("ui_right"):
			# If not steering
			_end("Shift") 
		else:
			# If steering
			if Input.is_action_pressed("ui_left") && Input.is_action_pressed("Left_Click"):
				_end("Drift") 
				return
			if Input.is_action_pressed("ui_right") && Input.is_action_pressed("Right_Click"):
				_end("Drift")
				return
	Player.Anim_Tree.set("parameters/Transition/current", 0)
				
	if Input.is_action_pressed("ui_up"):
		Player.curve_x += Player.GAS_STRENGTH
	if Input.is_action_pressed("ui_down"):
		Player.curve_x *= Player.BREAKING_STRENGTH
		if Player.curve_x < Player.LOW_SPEED_DEADZONE:
			Player.curve_x = 0
	if Input.is_action_pressed("ui_left"):
		steering_amount = Player.STEERING_STRENGTH
	if Input.is_action_pressed("ui_right"):
		steering_amount = -Player.STEERING_STRENGTH
	Player.curve_x = clamp(Player.curve_x, 0, 1)
	
	# Move
	var speed_y = Player.Speed_Curve.interpolate(Player.curve_x)
	Player.Moving_Dir = Player.Moving_Dir.linear_interpolate(-Player.transform.basis.z, Player.IDLE_GRIP)
	
	Player.velocity = Player.move_and_slide(Player.Moving_Dir*speed_y*Player.MAX_SPEED, Vector3.UP)
	Player.rotate_y(steering_amount*(1-speed_y/2))
	Player.curve_x *= Player.IDLE_FRICTION
	
	var blend_pos = Player.Anim_Tree.get("parameters/Steer_Blend/blend_amount")
	Player.Anim_Tree.set("parameters/Steer_Blend/blend_amount", lerp(blend_pos, -steering_amount/Player.STEERING_STRENGTH, 0.1))
	
	
