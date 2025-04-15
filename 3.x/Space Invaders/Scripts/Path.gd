extends Path

func _process(delta):
	$PathFollow.unit_offset += 0.1 * delta
