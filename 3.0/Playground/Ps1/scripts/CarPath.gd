extends Path



func _process(delta):
	$PathFollow.offset += 4 * delta
	
	
