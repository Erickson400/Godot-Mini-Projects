extends MeshInstance

const SPEED = 0.5

func _process(delta):
	rotate_x(SPEED*delta)
	rotate_y(SPEED*delta)
	rotate_z(SPEED*delta)
