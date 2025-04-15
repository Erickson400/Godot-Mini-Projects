extends Camera3D


const smooth_shake = 0.0002
const big_shake = 0.02

func _process(_delta):
	position = Vector3(randf(),randf(),randf()) * big_shake
	
