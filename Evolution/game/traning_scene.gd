extends Node

var AGENT_BODY_PATH = "res://game/entities/dino/dino.tscn"
var ga = GeneticAlgorithm.new(2, 1, AGENT_BODY_PATH, true, "dino_params")

func _ready():
	add_child(ga)
	self.place_bodies(ga.get_curr_bodies())


func place_bodies(bodies: Array) -> void:
	# remove the bodies from the last generation
	for last_gen_body in $Game/Population.get_children():
		last_gen_body.queue_free()
	# add the new bodies to the track
	for body in bodies:
		$Game/Population.add_child(body)
		body.position = $Game/DinoSpawn.position

func _process(delta):
	ga.next_timestep()
	if ga.all_agents_dead:
		ga.evaluate_generation()
		ga.next_generation()
		self.place_bodies(ga.get_curr_bodies())
	
	if Input.is_action_just_pressed("ui_select"):
		ga.evaluate_generation()
		ga.next_generation()
		self.place_bodies(ga.get_curr_bodies())

