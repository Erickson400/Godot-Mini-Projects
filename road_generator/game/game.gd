extends Node

onready var position:Vector2 = $RoadStart.position
onready var noise:OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	randomize()
	iterate()

func _unhandled_input(event):
	if event.is_action_pressed("ui_select"):
		iterate()

func iterate():
	$Line2D.clear_points()
	position = $RoadStart.position
	
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 200
	noise.persistence = 0.5
	
	$Line2D.add_point(position)	
	position.y -= rand_range(20, 100)
	position.x = noise.get_noise_1d(position.y)*100
	$Line2D.add_point(position)	
	for n in 100:
		position.y -= rand_range(0, 10)
		position.x = noise.get_noise_1d(position.y)*100
		#position.x += rand_range(-30, 30)
		$Line2D.add_point(position)	

