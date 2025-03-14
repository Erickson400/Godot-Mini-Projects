extends Spatial

var laser_scn = preload("res://Scenes/Laser.tscn")


const MAX_SPEED = 0.4
const Turn_Speed = 0.007
const MAX_ACCEL = 10
const MAX_DECCEL = 0.9
var velocity = 0
var bounce_val = 0

var can_shoot = true

func _process(delta):
	if Input.is_action_pressed("ui_left") and translation.x>-50:
		velocity -= MAX_ACCEL
	if Input.is_action_pressed("ui_right") and translation.x<50:
		velocity += MAX_ACCEL
	if Input.is_action_just_pressed("ui_select") and can_shoot:
		$Shooting_Flash.restart()
		$Shooting_Timer.start()
		can_shoot = false
		var laser_inst = laser_scn.instance()
		laser_inst.translation = to_global($Shoot_Spawn.translation)
		get_tree().get_root().add_child(laser_inst)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	$Rotation_Pivot. rotation.z = velocity*-Turn_Speed
	$Camera.rotation.z = velocity*-Turn_Speed*0.2
	translate(Vector3(velocity*MAX_SPEED*delta, 0,0))
	velocity *= MAX_DECCEL
	
	$Rotation_Pivot/Mesh.translation = Vector3(0,sin(bounce_val)*0.05,0)
	bounce_val+=10*delta


func _on_Shooting_Timer_timeout():
	can_shoot = true
