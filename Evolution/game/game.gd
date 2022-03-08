extends Node2D





func _process(delta):
	# Move and Roll back the cactus if off screen
	$Cactus.position.x -= 600*delta
	if $Cactus.position.x < -560:
		$Cactus.position = $CactusSpawn.position
