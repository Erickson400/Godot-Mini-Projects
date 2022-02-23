extends Node2D

## 	This is a Neural Network Demo.
## 	I have to make a game where the AI receives input, and returns outputs
## unlike the smart rockets where they had a DNA array.
## 
## 	I'm thinking of a TopDown Car that has to go through a track without 
## touching the walls.
## 	The Car will have raycasts around the front as inputs, and
## left or right steering for outputs
## 	
## 	1.Make a car scene and control it yourself as a test
## 	2.Make the sensors and make a function that gets the distance of collision
## 	3.Make a neural Network with 7 inputs, 3 outputs, 2 hidden layers, 
## and 10 hidden neurons.
##  4.Make genetic algorithm class
## 


var cactus_scn = preload("res://game/entities/cactus/cactus.tscn")
var dino_scn = preload("res://game/entities/dino/dino.tscn")
const CACTUS_SPEED = 500

var generation = 1
var all_crashed = false
const MUTATION_RATE = 1

func _enter_tree():
	$Cactus.position = $CactusSpawn.position
	# Spawn the Dinos
	for i in 100:
		var dino_inst = dino_scn.instance()
		$Population.add_child(dino_inst)
		dino_inst.position = $DinoSpawn.position

func _process(delta):
	# Roll back the cactus if off screen
	$Cactus.position.x -= CACTUS_SPEED*delta
	if $Cactus.position.x < -560:
		$Cactus.position = $CactusSpawn.position

	if OS.get_ticks_msec() % 50 == 0:
		# Check if all the cars crashed
		var local_all_crashed = true
		for n in $Population.get_children():
			if not n.crashed:
				local_all_crashed = false
		if local_all_crashed:
			all_crashed = true
			#print("All Crashed")
			#print($Population.get_children()[0].fitness)
			self.create_generation()

		
func create_generation():
	self.increase_gen()
	all_crashed = false
	print("Creating Generation ", generation)

	var dino_dnas = [] # Holds the new dna for each car

	# Selection
	for i in $Population.get_children().size():
		var selected_object = Genetic.pool_selection($Population.get_children())
		dino_dnas.append(selected_object.network.get_dna())

	# Crossover
	for i in $Population.get_children().size():
		var rand_dna_a = dino_dnas[randi() % dino_dnas.size()]
		var rand_dna_b = dino_dnas[randi() % dino_dnas.size()]
		dino_dnas[i] = Genetic.crossover(rand_dna_a, rand_dna_b)
	
	# Mutate
	for i in dino_dnas.size():
		Genetic.mutate(dino_dnas[i], MUTATION_RATE)

	# Reset the dinos, and cactus
	for i in $Population.get_children().size():
		print($Population.get_children()[i].fitness)
		$Population.get_children()[i].reset(dino_dnas[i], $DinoSpawn.position)
	$Cactus.position = $CactusSpawn.position



func increase_gen():
	generation += 1
	$Generation.text = "Gen " + str(generation)



func _unhandled_input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
