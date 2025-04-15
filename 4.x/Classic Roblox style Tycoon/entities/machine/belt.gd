extends StaticBody3D


var direction


func _enter_tree():
	direction = global_transform.basis.x.normalized()

