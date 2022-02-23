extends KinematicBody2D

var network = NeuralNetwork.new()
var fitness = 0
var timer = 0

const GRAVITY = 2000
var vertical_velocity = 0
var crashed = false

func reset(new_dna:Array, position_p:Vector2):
	network.set_dna(new_dna) 
	position = position_p 
	crashed = false
	visible = true
	vertical_velocity = 0



func _process(delta):
	# Apply Gravity
	vertical_velocity += GRAVITY * delta
	move_and_slide(Vector2(0,vertical_velocity), Vector2.UP)
	
	if not crashed:
		if is_on_floor():
			timer += int(OS.get_ticks_msec())
		
		# Jump if output is greater than 0
		if OS.get_ticks_msec() % 10 == 0:
			var network_data = network.get_data([self.get_sensor_distances()])
			if network_data[0] > 0.5:
				self.jump()
			
	

func get_sensor_distances():
	# Returns them normalized from 0 to 1
	var distances = []
	var sensor = $Sensor
	
	if sensor.is_colliding():
		var point = sensor.get_collision_point()
		var normalized_distance = point.distance_to(global_transform.origin)/500
		return normalized_distance
	return 1

func jump():
	if is_on_floor():
		vertical_velocity = -1000
		#var before = fitness
		#fitness = int(fitness * 0.5)
		#print("before: ", before, " after: ", fitness)







func _on_CactusChecker_area_entered(area):
	if area.is_in_group("cactus"):
		crashed = true
		visible = false
		fitness += timer
		#print("Crashed")
		#print(fitness)
