extends KinematicBody2D

## default fitness must be greater than 0
## param num_initial_links must not excede the the inputs to the power of outputs



#==========Physics Vars===========
var vertical_velocity = 0

signal death()

# Fitness is given every frame as long as its touching the ground
var fitness = 1

#=======NEAT funcs========
func sense() -> Array:
	var senses = [
		self.get_distance_to_cactus()/500,
		self.get_distance_to_ground()/200,
		get_parent().get_parent().cactus_speed,
	]
	return senses

func act(actions):
	if actions[0] > 0:
		self.jump()
	if actions[1] > 0:
		self.ground()

func get_fitness() -> float:
	return fitness












func _process(delta):
	# Apply Physics
	vertical_velocity += 2000 * delta
	move_and_slide(Vector2(0,vertical_velocity), Vector2.UP)
	if is_on_floor():
		fitness += 1*delta

func jump():
	if is_on_floor():
		vertical_velocity = -1000

func ground():
	vertical_velocity = 1000

func get_distance_to_cactus() -> float:
	var cactus = get_tree().get_nodes_in_group("cactus")[0]
	return cactus.position.x-self.position.x

func get_distance_to_ground() -> float:
	return self.position.y










func _on_CactusChecker_area_entered(area):
	if area.is_in_group("cactus"):
		hide()
		emit_signal('death')
