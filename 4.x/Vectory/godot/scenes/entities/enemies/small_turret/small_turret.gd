extends Node2D


const TILT_ANGLE = PI/3
const BULLET_SPEED = 300

@onready var bullet_scn = preload("res://scenes/entities/enemies/round_bullet.tscn")

@export var shoot_left = true
@export var shoot_center = true
@export var shoot_right = true


func _on_change_angle_timeout():
	var shooting_dirs: Array[String] = []

	if shoot_left:
		shooting_dirs.append("left")
	if shoot_center:
		shooting_dirs.append("center")
	if shoot_right:
		shooting_dirs.append("right")

	var final_dir = shooting_dirs.pick_random()

	if final_dir == "left":
		$Arm.rotation = -TILT_ANGLE
	if final_dir == "center":
		$Arm.rotation = 0
	if final_dir == "right":
		$Arm.rotation = TILT_ANGLE


func _on_shoot_timeout():
	var bullet_inst = bullet_scn.instantiate()
	get_parent().add_child(bullet_inst)
	bullet_inst.global_position = $Arm/Barrel.global_position
	bullet_inst.velocity = Vector2.from_angle($Arm/Barrel.global_rotation-PI/2) * BULLET_SPEED


func _on_init_shoot_offset_timeout():
	$Shoot.start()
	
	

