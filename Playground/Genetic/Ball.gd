extends Node
class_name Ball

#=========================Variables===========================
var position = Vector2(500,300)
var velocity = Vector2(0,0)
var vel_multiplier = 0.1
var size = 10
var color = Color.red
 
var dna_data:DNA
var dna_index = 0
var position_data = []

var spawn_point = Vector2(0,0)

#=========================Functions===========================
func Iterate() -> bool:
	if dna_index < dna_data.LIFE_TIME:
		velocity += dna_data.dna[dna_index]
		
		#position += dna_data.dna[dna_index] * vel_multiplier
		position += velocity * vel_multiplier
		position_data.append(position)
		dna_index += 1
		return false
	else:
		return true # Finished
	
func Fitness(target:Vector2) -> float:
	# Get the average distance between all velocities
	
	var sum:float = 0
	for n in position_data:
		sum += position.distance_to(target)
	var average = sum / position_data.size()
	
	var window = Rect2(Vector2.ZERO, Vector2(1024, 600))
	if not window.has_point(position):
		return 10000 - average - 1000

	return 10000 - average
	
	
	
	# The greater the distance the higher the fitness (higher chance of been choosen)
#	var ret = 10000 - position.distance_to(target)
#	var window = Rect2(Vector2.ZERO, Vector2(1024, 600))
#	if not window.has_point(position):
#		return ret - 100
#	return ret
	


#=========================Override Functions===========================
func _init(p_spawn_point, p_dna:DNA = null):
	spawn_point = p_spawn_point
	position = p_spawn_point
	if p_dna == null:
		dna_data = DNA.new()
	else:
		dna_data = p_dna
	

