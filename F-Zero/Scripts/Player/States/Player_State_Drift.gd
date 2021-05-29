extends State_Node

func physics_process(delta):
	var Drifting_Side = "idle"
	
	# Input
	if Input.is_action_pressed("Left_Click") == Input.is_action_pressed("Right_Click"):
		_end("Driving") # Both buttons are down/up
		return
	if Input.is_action_pressed("ui_left") && Input.is_action_pressed("Right_Click"):
		_end("Driving") # Pressing oposite key
		return
	if Input.is_action_pressed("ui_right") && Input.is_action_pressed("Left_Click"):
		_end("Driving") # Pressing oposite key
		return
		
	if Input.is_action_pressed("Left_Click") && Input.is_action_pressed("ui_left"):
		Drifting_Side = "left"
	elif Input.is_action_pressed("Right_Click") && Input.is_action_pressed("ui_right"):
		Drifting_Side = "right"
	else:
		_end("Driving") # If the Drifting_Side is null
		return
	Player.Anim_Tree.set("parameters/Transition/current", 2)
	
	# Move
	if Input.is_action_pressed("ui_up"):
		Player.curve_x += Player.GAS_STRENGTH
	if Input.is_action_pressed("ui_down"):
		Player.curve_x *= Player.BREAKING_STRENGTH
		if Player.curve_x < Player.LOW_SPEED_DEADZONE:
			Player.curve_x = 0
	Player.curve_x = clamp(Player.curve_x, 0, 1)
	
	var speed_y = Player.Speed_Curve.interpolate(Player.curve_x)
	var steering_amount = 0
	var rotated_basis:Vector3 = Player.transform.basis.z
	
	match Drifting_Side:
		"left":
			steering_amount = Player.DRIFTING_STRENGTH
			rotated_basis = rotated_basis.linear_interpolate(rotated_basis.rotated(Vector3.UP, Player.DRIFT_ANGLE), 0.001)
		
		"right":
			steering_amount = -Player.DRIFTING_STRENGTH
			rotated_basis = rotated_basis.linear_interpolate(rotated_basis.rotated(Vector3.UP, -Player.DRIFT_ANGLE), 0.001)
		
	Player.Moving_Dir = Player.Moving_Dir.linear_interpolate(-rotated_basis, Player.DRIFT_GRIP)
	Player.velocity = Player.move_and_slide(Player.Moving_Dir*speed_y*Player.MAX_SPEED, Vector3.UP)
	Player.rotate_y(steering_amount*(1-speed_y/2))
	Player.curve_x *= Player.IDLE_FRICTION
	
	var blend_pos = Player.Anim_Tree.get("parameters/Drift_Blend/blend_amount")
	Player.Anim_Tree.set("parameters/Drift_Blend/blend_amount", lerp(blend_pos, -steering_amount/Player.STEERING_STRENGTH, 0.1))
	
	
	

# Called my the drift animations
func Tilted_Left():
	Player.get_node("Rotation_Pivot/Mesh_Pivot/Left_Smoke").emitting = true
func Tilted_Right():
	Player.get_node("Rotation_Pivot/Mesh_Pivot/Right_Smoke").emitting = true





