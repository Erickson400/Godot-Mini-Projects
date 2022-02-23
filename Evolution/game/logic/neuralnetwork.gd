extends Node
class_name NeuralNetwork

## Each will have reference to it's previous layer.
## To get the value, calculate the neurons from input to output order.

class InputNeuron:
	var value = 0
	func _init(input_value = 0):
		value = input_value

class Neuron:
	var inputs = [] # References to previous neurons
	var weights = []
	var bias = rand_range(-1, 1)
	var value = 0
	
	func _init(inputs_p:Array):
		# Store the input references and initialize random weights
		inputs = inputs_p
		for i in inputs.size():
			weights.append(randf())
			
	func calculate():
		# Does the math and sets the output to [value]
		
		# Multiply the input's values by the weights
		var weighted_sum = 0
		for i in inputs.size(): 
			if inputs[i].has_method("calculate"):
				# Only calculate if its not an input neuron
				inputs[i].calculate()
			weighted_sum += inputs[i].value*weights[i]
			
		# Add the bias and apply the activation function
		var sum = weighted_sum + bias 
		value = tanh(sum)




var input_neurons = []
var layer1_neurons = []
var output_neurons = []

func _init(existing_dna:Array = []):
	randomize()
	
	# Initialize the neurons and set their input references
	for i in 1:
		input_neurons.append(InputNeuron.new(0.5))
	for i in 3:
		layer1_neurons.append(Neuron.new(input_neurons))
	for i in 1:
		output_neurons.append(Neuron.new(layer1_neurons))
		
	if not existing_dna.empty():
		self.set_dna(existing_dna)

func get_data(new_inputs:Array) -> Array:
	# Get the output depending on the inputs
	
	for i in input_neurons.size():
		input_neurons[i].value = new_inputs[i]
	
	for i in layer1_neurons.size():
		layer1_neurons[i].calculate()
	for i in output_neurons.size():
		output_neurons[i].calculate()
	
	var outputs = []
	for i in output_neurons.size():
		outputs.append(output_neurons[i].value)
	
	return outputs

func get_dna() -> Array:
	var dna = []
	for i in layer1_neurons.size():
		dna.append(layer1_neurons[i].bias)
		for j in layer1_neurons[i].weights.size():
			dna.append(layer1_neurons[i].weights[j])
			
	for i in output_neurons.size():
		dna.append(output_neurons[i].bias)
		for j in output_neurons[i].weights.size():
			dna.append(output_neurons[i].weights[j])
	
	return dna

func set_dna(new_dna:Array):
	layer1_neurons[0].bias = new_dna[0]
	layer1_neurons[0].weights[0] = new_dna[1]
	
	layer1_neurons[1].bias = new_dna[2]
	layer1_neurons[1].weights[0] = new_dna[3]
	
	layer1_neurons[2].bias = new_dna[4]
	layer1_neurons[2].weights[0] = new_dna[5]
	
	output_neurons[0].bias = new_dna[6]
	output_neurons[0].weights[0] = new_dna[7]
	output_neurons[0].weights[1] = new_dna[8]
	output_neurons[0].weights[2] = new_dna[9]
	
	
	
	
	# First layer, 3 neurons
#	for i in layer1_neurons.size():
#		layer1_neurons[i].bias = new_dna[i*2]   # 0 min
#		# Set weights
#		for j in 1:
#			layer1_neurons[i].weights[j] = new_dna[i*2+j+1]   # 79 max
	
	# output layer, 1 neurons
	
	
	
#	for i in output_neurons.size():
#		output_neurons[i].bias = new_dna[(i*4)+10]
#		# Set weights
#		for j in layer1_neurons.size():
#			output_neurons[i].weights[j] = new_dna[(i*4+j+1)+80]
	


