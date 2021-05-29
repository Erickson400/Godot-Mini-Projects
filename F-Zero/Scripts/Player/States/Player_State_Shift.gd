extends State_Node

func physics_process(delta):
	var Shifting_Side
	
	# Input
	if Input.is_action_pressed("Left_Click") == Input.is_action_pressed("Right_Click"):
		_end("Driving") # Both buttons are down/up
		return
	if Input.is_action_pressed("Left_Click") && Input.is_action_pressed("ui_right"):
		_end("Driving")  # Steering right but pressing drift left
		return
	if Input.is_action_pressed("Right_Click") && Input.is_action_pressed("ui_left"):
		_end("Driving") # Steering Left but pressing drift right
		return
	if Input.is_action_pressed("ui_left") ||  Input.is_action_pressed("ui_right"):
		_end("Driving")
		return
	Player.Anim_Tree.set("parameters/Transition/current", 1)
	
	if Input.is_action_pressed("Left_Click"):
		Shifting_Side = "left"
	if Input.is_action_pressed("Right_Click"):
		Shifting_Side = "right"
		
	# Accelerate & Deccelerate
	if Input.is_action_pressed("ui_up"):
		Player.curve_x += Player.GAS_STRENGTH
	if Input.is_action_pressed("ui_down"):
		Player.curve_x *= Player.BREAKING_STRENGTH
		if Player.curve_x < Player.LOW_SPEED_DEADZONE:
			Player.curve_x = 0
	Player.curve_x = clamp(Player.curve_x, 0, 1)
	
	# Move
	var rotated_basis = Vector3.ZERO
	var speed_y = Player.Speed_Curve.interpolate(Player.curve_x)
	
	match Shifting_Side:
		"left":
			rotated_basis = Player.transform.basis.rotated(Vector3.UP, Player.SHIFT_ANGLE)
		"right":
			rotated_basis = Player.transform.basis.rotated(Vector3.UP, -Player.SHIFT_ANGLE)
	
	Player.Moving_Dir = Player.Moving_Dir.linear_interpolate(-rotated_basis.z, Player.IDLE_GRIP)
	Player.velocity = Player.move_and_slide(Player.Moving_Dir*speed_y*Player.MAX_SPEED, Vector3.UP)
	Player.curve_x *= Player.IDLE_FRICTION

	var blend_pos = Player.Anim_Tree.get("parameters/Shift_Blend/blend_amount")
	var Shift_amount = 0
	match Shifting_Side:
		"left":
			Shift_amount = -1
		"right":
			Shift_amount = 1
	
	
	Player.Anim_Tree.set("parameters/Shift_Blend/blend_amount", lerp(blend_pos, Shift_amount, 0.1))
	

