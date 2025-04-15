extends Node

signal screen_updated(texture)

const SCREEN_SIZE = 200
const SCREEN_SIZE_H = SCREEN_SIZE>>1

# Set by the player Node
var player_pos = Vector2.ZERO
var player_facing_vec = Vector2.ZERO
var player_angle = 0
var val1 = 1.1
var val2 = 0.4

@onready var display_sprite: Sprite2D = get_tree().get_root().get_node("Main/DisplaySprite")


func _process(_delta: float) -> void:
	var mat = display_sprite.material as ShaderMaterial
	# Change the DisplaySprite noise resolution to screen size
	# Set project window size and SCREEN_SIZE variables
	mat.set_shader_parameter("screen_size_h", SCREEN_SIZE_H)
	mat.set_shader_parameter("player_pos", player_pos)
	mat.set_shader_parameter("player_angle", player_angle)
	mat.set_shader_parameter("val1", val1)
	mat.set_shader_parameter("val2", val2)









