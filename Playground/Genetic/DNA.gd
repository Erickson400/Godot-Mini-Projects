extends Node
class_name DNA

#=========================Variables===========================
const LIFE_TIME = 1200 #Frames
var dna = [] # Each index is a frame, the element is the velocity it must add

#=========================Functions===========================
static func PoolSelection(values = [], chances=[]):
	if values.size() != chances.size():
		print("PoolSelection, values do not match")
		return

	# Normalize
	var norm_scores = chances.duplicate()
	var sum = 0
	for n in norm_scores:
		sum += n
	for i in norm_scores.size():
		norm_scores[i] = float(norm_scores[i]) / sum

	# Pick one
	var index = 0
	var r = randf()
	while r > 0:
		r -= norm_scores[index]
		index += 1
	index -= 1
	return values[index]

func Mutate(rate:float): # rate must be between 0 and 1 (0% - 100% )
	## The rate is the percentage that the dna will change.
	## if its 0.5 then it will change 50% of the dna into randomness
	var rand = randf()
	var max_index = int(rate * 100 * rand)
	for i in max_index:
		dna[i] = Vector2(randf()*2-1, randf()*2-1)
func CrossOver(a:DNA) -> DNA:
	# Take first half of the the DNA
	# then take the Last half of A and add them up
	
	# Chooses a random index on the dna
	var max_index = randi() % a.dna.size()
	
	# Add the dna's at a random split
	var crossed_dna = []
	for i in max_index:
		crossed_dna.append(self.dna[i])
	for i in range(max_index, a.dna.size()):
		crossed_dna.append(a.dna[i])
		
	return get_script().new(crossed_dna)
	
#	var crossed_dna = []
#	for i in LIFE_TIME/2:
#		crossed_dna.append(self.dna[i])
#	for i in range(LIFE_TIME/2, LIFE_TIME):
#		crossed_dna.append(a.dna[i])
		
	
func _GenerateRandomDNAData() -> Array:
	var data = []
	for i in LIFE_TIME:
		data.append(Vector2(randf()*2-1, randf()*2-1))
	return data

#=========================Override Functions===========================
func _init(new_dna = []):
	if new_dna.empty():
		dna = _GenerateRandomDNAData()
	else:
		dna = new_dna
	





















