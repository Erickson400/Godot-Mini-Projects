extends Node2D

const SPEED = 50
const TURN_SPEED = 2
const DEFAULT_ANGLE = 0 #PI/2

func _ready() -> void:
	rotate(DEFAULT_ANGLE)


func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rotate(-TURN_SPEED * delta)
	if Input.is_action_pressed("right"):
		rotate(TURN_SPEED * delta)
	if Input.is_action_pressed("forward"):
		translate(global_transform.x * SPEED * delta)
	if Input.is_action_pressed("back"):
		translate(global_transform.x * -SPEED * delta)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	GameBus.player_pos = global_position
	GameBus.player_angle = rotation
	GameBus.player_facing_vec = global_transform.x







