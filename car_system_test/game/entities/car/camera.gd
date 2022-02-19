extends Spatial

onready var body = get_parent().get_node("Body")

func _process(_delta):
	# Move the pivot to the car
	global_transform.origin = body.global_transform.origin
	
	# Rotate it on the car's global Y axis
	rotation.y = body.rotation.y



