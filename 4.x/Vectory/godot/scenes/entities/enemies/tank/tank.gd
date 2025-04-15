extends Area2D


const TILT_ANGLE = PI/6
const BULLET_SPEED = 350
const PATROL_SPEED = 50

@onready var bullet_scn = preload("res://scenes/entities/enemies/round_bullet.tscn")
@onready var initial_pos = position.x
@export var min_patrol: float = -50
@export var max_patrol: float = 50

var current_patrol = 0
var current_patrol_direction = "right"




func _process(delta):
	if current_patrol_direction == "right":
		current_patrol += PATROL_SPEED * delta
	elif current_patrol_direction == "left":
		current_patrol -= PATROL_SPEED * delta

	if current_patrol > max_patrol:
		current_patrol_direction = "left"
	if current_patrol < min_patrol:
		current_patrol_direction = "right"
	
	position.x = initial_pos + current_patrol



func _on_init_offset_timeout():
	$ChangeAngle.start()


func _on_shoot_timeout():
	var bullet_inst = bullet_scn.instantiate()
	get_parent().add_child(bullet_inst)
	bullet_inst.enable_big_bullet()
	bullet_inst.global_position = $Arm/Barrel.global_position
	bullet_inst.velocity = Vector2.from_angle($Arm/Barrel.global_rotation-PI/2) * BULLET_SPEED


func _on_change_angle_timeout():
	$Arm.rotation = [-TILT_ANGLE, 0, TILT_ANGLE].pick_random()
	
