extends KinematicBody

var Speed_Curve = preload("res://Assets/Logic/Acceleration_Curve.tres")
onready var Anim_Tree = $Anim_States_Tree

var MAX_SPEED = 50
const LOW_SPEED_DEADZONE = 0.01 # Snaps to 0 if in low range
const GAS_STRENGTH = 0.01
const BREAKING_STRENGTH = 0.98
const STEERING_STRENGTH = 0.05
const DRIFTING_STRENGTH = 0.07
const IDLE_GRIP = 0.02 # Grip amount, lower = ice
const DRIFT_GRIP = 0.08
const SHIFT_ANGLE = PI/4
const DRIFT_ANGLE = PI/9

const IDLE_FRICTION = 0.995
const STEERING_FRICTION = 0.8

var Moving_Dir:Vector3 # Sliding towards

# Global for states
var curve_x = 0 # 0-1
var velocity = 0
var anim_bounce = 0
var Drift_Tilted_Side_Smoke = "None"

# Jump
var gravity = 1
var is_on_Ground = false
var V_velocity = 0

func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
func _process(delta):
	# Jump
	var speed = velocity.length() / MAX_SPEED
	$Rotation_Pivot/Mesh_Pivot.translation.y = sin(anim_bounce)*0.2 * speed
	anim_bounce += 0.01 * speed + 0.1
	
	# Camera_FOV
	$Camera.fov = 70 + (20*speed)
	get_node("Rotation_Pivot/Mesh_Pivot/Thruster").speed_scale = 0.5 + (2*speed)
	
	# Drift particles
	get_node("Rotation_Pivot/Mesh_Pivot/Right_Smoke").emitting = false
	get_node("Rotation_Pivot/Mesh_Pivot/Left_Smoke").emitting = false

func _physics_process(delta):
	# Jump
	if is_on_Ground:
		V_velocity = gravity
		if get_parent().get_node("Map"):
			get_parent().get_node("Map").get_node("Outside_Collision").disabled = false
			get_parent().get_node("Map").get_node("Inside_Collision").disabled = false

	else:
		V_velocity += gravity
	move_and_slide(Vector3.DOWN*V_velocity, Vector3.UP)
	is_on_Ground = is_on_floor()
	

func Jump():
	V_velocity = -30
	move_and_slide(Vector3.DOWN*V_velocity, Vector3.UP)
	is_on_Ground = is_on_floor()
	if get_parent().get_node("Map"):
		get_parent().get_node("Map").get_node("Outside_Collision").disabled = true
		get_parent().get_node("Map").get_node("Inside_Collision").disabled = true











func _on_Timer_Boost_timeout():
	MAX_SPEED = 40
