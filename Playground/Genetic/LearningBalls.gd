extends Node2D

#========================Variables===========================
const STARTING_POS = Vector2(100,350)#Vector2(60,554)
const TARGET_POS = Vector2(950,350)
var population = [] # Balls
var generaion = 0

#========================Functions===========================
func _init():
	randomize()
	# Initialize population
	population.resize(100)
	for i in population.size():
		population[i] = Ball.new(STARTING_POS)
	
func _draw():
	# Draw the population
	for i in population.size():
		draw_circle(population[i].position, population[i].size, population[i].color)
	
	# Draw the starting and target points
	draw_circle(STARTING_POS, 10, Color.orange)
	draw_circle(TARGET_POS, 10, Color.purple)
func _process(_delta):
	$FPS.text = "FPS: " + String(Engine.get_frames_per_second())
	$Generation.text = "Generation: " + String(generaion)

	var finished
	for i in population.size():
		for j in 14:
			finished = population[i].Iterate()
		
	if finished == true:
		FinishedGeneration()
	update()

func FinishedGeneration():
	generaion+=1
	var temp_population = []
	
	# Get their fitness
	var chances = []
	for n in population:
		chances.append(n.Fitness(TARGET_POS))
	
	while temp_population.size() < population.size():
		# Get two random ball depending on its fitness
		var ball1:Ball = DNA.PoolSelection(population, chances)
		var ball2:Ball = DNA.PoolSelection(population, chances)
		
		# Crossover
		var new_dna = ball1.dna_data.CrossOver(ball2.dna_data)
		
		# Mutate
		new_dna.Mutate(0.9)
		
		# Add the new ball to the temp population
		temp_population.append(Ball.new(STARTING_POS, new_dna))
	
	# After the temp_population is full, set the main population to it
	population.clear()
	population = temp_population.duplicate()
		



#--------Loop--------
#
## Generate new generation
#
## Natural Selection
#	# Fitness function
#	# Take the best of the DNAs
#
## Crossover
#
## Mutation
#
## Breed new generation


