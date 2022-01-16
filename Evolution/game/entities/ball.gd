extends Node2D
class_name Ball

var wall = Rect2()
var dna = NeuralNetwork.new()

func _ready():
	dna.init_random()

func _process(delta):
	position.x += 5
	dna.Inputs = position.x/1024
	dna.update()
	if dna.Output > 0:
		position.y = 200
	else:
		position.y = 400
	
	if position.x > 1024:
		position.x = 0
		
	
	
#func _input(_event):
#	if Input.is_action_pressed("ui_select"):
#		position.y = 200
#	else:
#		position.y = 400


func _draw():
	draw_circle(Vector2.ZERO, 10, Color.red)


