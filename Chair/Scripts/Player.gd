extends RigidBody



var speed = 200

func _ready():
	friction = 100

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		apply_central_impulse(Vector3.RIGHT*speed)
	if Input.is_action_pressed("ui_up"):
		apply_central_impulse(Vector3.FORWARD*speed)
	if Input.is_action_pressed("ui_left"):
		apply_central_impulse(Vector3.LEFT*speed)
	if Input.is_action_pressed("ui_down"):
		apply_central_impulse(Vector3.BACK*speed)
	
func _process(delta):
	$Icon.global_transform.origin = global_transform.origin
	$Icon.global_transform.basis = Basis()
	
	
	
