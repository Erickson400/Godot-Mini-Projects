extends Area

var rotate_range = 40
var rotation_speed= Vector3(0,0,0)
var speed = 40

func _ready():
	$Mesh.scale_object_local(Vector3.ONE*rand_range(1, 4))
	$CollisionShape.shape.radius = $Mesh.scale.x*1.5
	rotation_speed.x = rand_range(0, PI/rotate_range)
	rotation_speed.y = rand_range(0, PI/rotate_range)
	rotation_speed.z = rand_range(0, PI/rotate_range)

func _process(delta):
	rotate_x(rotation_speed.x)
	rotate_y(rotation_speed.y)
	rotate_z(rotation_speed.z)
	global_translate(Vector3(0,0,speed*delta))
	
	if global_transform.origin.z>20:
		queue_free()
	
	
	
	
