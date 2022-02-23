extends Area2D

const SPEED = 80
const TURN_SPEED = 20
var crashed = false

var network = NeuralNetwork.new()
var fitness = 0
var timer = 0
# touching a checkpoint gives 10 fitness.
# every half second without crashing it gets 1 fitness



func reset(new_dna:Array, position_p:Vector2):
	network.set_dna(new_dna) 
	position = position_p
	rotation = 0
	crashed = false
	fitness = 0
	timer = 0


func _process(delta):
	if not crashed:
		timer += int(OS.get_ticks_msec() / 100)
		global_translate(global_transform.x*SPEED*delta)
		
		if OS.get_ticks_msec() % 10 == 0:
			var network_data = network.get_data(self.get_sensor_distances())
			if network_data[0] > network_data[1] and network_data[0] > network_data[2]:
				rotate(-TURN_SPEED*delta) 
			elif network_data[1] > network_data[0] and network_data[1] > network_data[2]:
				pass
				#global_translate(global_transform.x*SPEED*5*delta) 
			elif network_data[2] > network_data[1] and network_data[2] > network_data[0]:
				rotate(TURN_SPEED*delta)

func get_sensor_distances() -> Array:
	# Returns them normalized from 0 to 1
	var distances = []
	for r in get_node("Sensors").get_children():
		if r.is_colliding():
			var point = r.get_collision_point()
			var normalized_distance = point.distance_to(global_transform.origin)/100
			distances.append(normalized_distance)
		else:
			distances.append(0)
	return distances







func _on_Car_area_entered(area):
	if area.is_in_group("wall"):
		crashed = true
		fitness += timer
	if area.is_in_group("checkpoint"):
		fitness += 500

func _on_FitnessReward_timeout():
	return
	fitness += 1
	if not crashed:
		$FitnessReward.start()
