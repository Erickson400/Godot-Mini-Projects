extends Node2D

const PIXEL = preload("res://assets/pixel.png")
const PLANK_WIDTH = 20
const HEIGHT = 100
const LENGTH = 20 # plank and shadow pairs
const OFFSET = 100
const PLANK_LIGHT_FADE_DISTANCE = 1000
const SHADOW_LIGHT_FADE_DISTANCE = 600
const SPEED = 300

@export var  PLANK_LIGHT_COLOR = Color.SADDLE_BROWN
@export var  PLANK_DARK_COLOR = Color.SADDLE_BROWN
@export var light_source: Node2D = null
@export var bg_color: Color = Color.WHITE
@export var shadow_color: Color = Color.BLACK


func _ready():
	$BG.modulate = bg_color
	$BG.scale = Vector2(5000, HEIGHT)
	
	for i in LENGTH:
		var plank = Sprite2D.new()
		plank.position = Vector2(i * OFFSET, -float(HEIGHT)/2)
		plank.scale = Vector2(PLANK_WIDTH, HEIGHT)
		plank.centered = false
		plank.texture = PIXEL
		plank.modulate = PLANK_DARK_COLOR
		$Planks.add_child(plank)
		
		var shadow = Sprite2D.new()
		shadow.position = Vector2(i * OFFSET + PLANK_WIDTH, -float(HEIGHT)/2)
		shadow.scale = Vector2(OFFSET - PLANK_WIDTH, HEIGHT)
		shadow.centered = false
		shadow.texture = PIXEL
		shadow.modulate = shadow_color
		$Shadows.add_child(shadow)


func  _process(delta: float) -> void:
	position.x -= SPEED * delta
	if position.x < -1400:
		position.x += 400
	
	for plank in $Planks.get_children():
		var distance = abs(plank.global_position.x - light_source.global_position.x)
		if distance > 0 and distance < PLANK_LIGHT_FADE_DISTANCE:
			var unit_distance = distance / PLANK_LIGHT_FADE_DISTANCE
			var new_color = PLANK_DARK_COLOR.lerp(PLANK_LIGHT_COLOR, 1-unit_distance)
			plank.modulate = new_color
		else:
			plank.modulate = PLANK_DARK_COLOR
	
	for shadow in $Shadows.get_children():
		var distance = abs(shadow.global_position.x - light_source.global_position.x)
		if distance > 0 and distance < SHADOW_LIGHT_FADE_DISTANCE:
			var unit_distance = distance / SHADOW_LIGHT_FADE_DISTANCE
			shadow.scale.x = (OFFSET - PLANK_WIDTH) * unit_distance
			#var new_color = PLANK_DARK_COLOR.lerp(PLANK_LIGHT_COLOR, 1-unit_distance)
			#plank.modulate = new_color
		else:
			shadow.scale.x = OFFSET - PLANK_WIDTH
			#plank.modulate = PLANK_DARK_COLOR
	
	
	
	
