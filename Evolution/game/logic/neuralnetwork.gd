extends Node
class_name NeuralNetwork
# Only has 1 input and 1 output

var Inputs = 0
var Weights = 0
var Bias = 0
var Output = 0 # -1 to 1

func init_random():
	Weights = rand_range(-1, 1)
	Bias = rand_range(-1, 1)

func update():
	Output = Inputs * Weights
	Output += Bias
	#Output = sigmoid(Output)

func sigmoid(x):
	return 1/(1+exp(-x))
