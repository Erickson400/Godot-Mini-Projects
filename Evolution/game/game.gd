extends Node2D



var cactus_speed = 400

var gen = 1

func _process(delta):
	# Move and Roll back the cactus if off screen
	$Cactus.position.x -= cactus_speed*delta
	if $Cactus.position.x < -560:
		$Cactus.position = $CactusSpawn.position
		cactus_speed += 40


func inc_generation_text():
	gen += 1
	$Generation.text = "Gen %d" % gen
	cactus_speed = 400
	
