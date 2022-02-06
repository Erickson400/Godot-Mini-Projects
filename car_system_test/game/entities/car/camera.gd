extends Spatial

func _process(_delta):
	var body = get_parent().get_node("Body")
	var body_pos = body.global_transform.origin
	global_transform.origin = body_pos
	rotation.y = body.rotation.y



