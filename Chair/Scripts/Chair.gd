extends RigidBody


func _process(delta):
	$Icon.global_transform.origin = global_transform.origin
	$Icon.global_transform.basis = Basis()

