extends State


enum State {
	FLYING,
	LANDED,
	DESTROYED,
}
enum {
	LEFT,
	MIDDLE,
	RIGHT,
}


const MAX_SPEED := Vector2(220,220)
const ACCELERATION := 2.0
const DECCELERATION := 0.999 # 0 - 1

@export var character: CharacterBody2D
@export var fire_rate_timer: Timer
@export var land_state: State
@export var front_propeller: Node3D
@export var back_propeller: Node3D
@export var tilt_pivot: Node3D
@export var turn_pivot: Node3D
@export var right_barrel: Node2D
@export var middle_barrel: Node2D
@export var left_barrel: Node2D
@export var barrel_pivot: Node2D


var state := State.FLYING
var facing_direction := RIGHT
var fire_rate_finished := true
var last_side_shot = LEFT

@onready var sharp_bullet_scn := preload("res://scenes/entities/player/sharp_bullet.tscn")
@onready var camera_focus = {
	LEFT: character.get_node("LeftCameraFocus"),
	RIGHT: character.get_node("RightCameraFocus"),
	MIDDLE: character.get_node("MiddleCameraFocus"),
}


func update(delta):
	var target_propeller_speed = character.PROPELLER_SPEEDS["idle"]
	var tilt_angle = 0
	
	# Handle movement
	character.moved.emit(camera_focus[facing_direction].global_position)
	
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("Right"):
		move_direction.x += 1
		tilt_angle -= PI/6
	if Input.is_action_pressed("Left"):
		move_direction.x -= 1
		tilt_angle += PI/6
	if Input.is_action_pressed("Up"):
		target_propeller_speed = character.PROPELLER_SPEEDS["up"]
		move_direction.y -= 1
	if Input.is_action_pressed("Down"):
		target_propeller_speed = character.PROPELLER_SPEEDS["down"]
		move_direction.y += 1
		
	move_direction = move_direction.normalized()
	character.velocity += move_direction * ACCELERATION

	character.velocity.x = clamp(character.velocity.x, -MAX_SPEED.x, MAX_SPEED.x)
	character.velocity.y = clamp(character.velocity.y, -MAX_SPEED.y, MAX_SPEED.y)
	
	# Bounce if collided with bonk object
	var kine: KinematicCollision2D = character.move_and_collide(character.velocity * delta, true)
	if kine != null:
		if kine.get_collider().is_in_group("bonk"):
			character.velocity = character.velocity.reflect(kine.get_normal().rotated(PI/2)) * 1.01
	
	character.move_and_slide()
	character.velocity *= DECCELERATION
	
	# Handle Helicopter animations
	front_propeller.rotate_y(target_propeller_speed * delta)
	back_propeller.rotate_x(10 * delta)
	
	var tilt_lerp_magnitude = 0.03
	tilt_pivot.rotation.x = lerpf(tilt_pivot.rotation.x, tilt_angle, tilt_lerp_magnitude)
	barrel_pivot.rotation = -tilt_pivot.rotation.x 
	
	var facing_angle = 0
	match facing_direction:
		LEFT:
			facing_angle = PI
		MIDDLE:
			facing_angle = PI/2
		RIGHT:
			facing_angle = 0
			
	turn_pivot.rotation.y = lerpf(turn_pivot.rotation.y, facing_angle, 4 * delta)
	
	if Input.is_action_pressed("Space") and fire_rate_finished:
		fire_rate_finished = false
		fire()
		fire_rate_timer.start()


func input(event):
	if event.is_action_pressed("TurnLeft"):
		if facing_direction == RIGHT:
			facing_direction = MIDDLE
		elif facing_direction == MIDDLE:
			facing_direction = LEFT
	if event.is_action_pressed("TurnRight"):
		if facing_direction == LEFT:
			facing_direction = MIDDLE
		elif facing_direction == MIDDLE:
			facing_direction = RIGHT


func enable_landing():
	transitioned_to.emit(self, land_state)


func fire():
	if facing_direction == RIGHT:
		var bullet_inst = sharp_bullet_scn.instantiate()
		character.get_parent().add_child(bullet_inst)
		bullet_inst.position = right_barrel.global_position
		bullet_inst.rotation = barrel_pivot.rotation
		last_side_shot = RIGHT if last_side_shot == LEFT else LEFT
		
	if facing_direction == LEFT:
		var bullet_inst = sharp_bullet_scn.instantiate()
		character.get_parent().add_child(bullet_inst)
		bullet_inst.position = left_barrel.global_position
		bullet_inst.rotation = barrel_pivot.rotation-PI
		last_side_shot = RIGHT if last_side_shot == LEFT else LEFT
		
	
	if facing_direction == MIDDLE:
		var bullet_inst = sharp_bullet_scn.instantiate()
		character.get_parent().add_child(bullet_inst)
		
		if last_side_shot == LEFT:
			bullet_inst.position = left_barrel.global_position
		elif last_side_shot == RIGHT:
			bullet_inst.position = right_barrel.global_position
		
		bullet_inst.rotation = barrel_pivot.rotation+PI/2
		last_side_shot = RIGHT if last_side_shot == LEFT else LEFT


func _on_fire_rate_timeout():
	fire_rate_finished = true
	
	


