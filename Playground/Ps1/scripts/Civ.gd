extends Spatial

var face = 0

func _process(delta):
	rotation.y = sin(face)/5
	face += 1 *delta
