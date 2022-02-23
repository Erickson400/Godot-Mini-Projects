extends Node
class_name Genetic













static func mutate(dna, chance):
	# chance is from 0 to 100. 0 means no mutation (no changes)
	for i in dna.size():
		if randi() % 100 < round(chance):
			dna[i] = randf()

static func crossover(dna_a:Array, dna_b:Array) -> Array:
	var half_a = dna_a.slice(0,dna_a.size()/2)
	var half_b = dna_b.slice(dna_b.size()/2+1, dna_b.size())
	half_a.append_array(half_b)
	return half_a

static func generate_random_dna(size = 223) -> Array:
	var dna = []
	dna.resize(size)
	for i in size:
		dna[i] = randf()
	return dna




static func pool_selection(objects:Array):
	# Returns a random object depending on it's fitness.
	# The greater the fitness, the more often it will be selected
	# [objects] should have a fitness variable
	
	# Get the highest fitness
	var max_fitness = 1
	for n in objects:
		if n.fitness > max_fitness:
			max_fitness = n.fitness
	
	# Accept or Reject
	while true:
		# Get a random object
		var partner = objects[randi() % objects.size()]
		
		# Get a random fitness range
		var r = randi() % max_fitness
		
		if r < partner.fitness:
			return partner












