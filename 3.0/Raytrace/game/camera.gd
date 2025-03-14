extends Camera

export(int) var SPEED = 10
const MOUSE_SENSITIVITY := Vector2(0.8, 0.9) 
export(bool) var fullscreen = false

func _ready():
	OS.window_fullscreen = fullscreen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		# Camera movement
		rotation_degrees.y -= event.relative.x*MOUSE_SENSITIVITY.x
		rotation_degrees.x -= event.relative.y*MOUSE_SENSITIVITY.y
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)

func _process(delta):
	# Movement
	var moveDir := Vector3(0,0,0)
	if Input.is_action_pressed("ui_up"):
		moveDir.z-=1
	if Input.is_action_pressed("ui_left"):
		moveDir.x-=1
	if Input.is_action_pressed("ui_down"):
		moveDir.z+=1
	if Input.is_action_pressed("ui_right"):
		moveDir.x+=1
	if Input.is_action_pressed("Elevate"):
		moveDir.y+=1
	if Input.is_action_pressed("Desend"):
		moveDir.y-=1
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	translate_object_local(moveDir*SPEED*delta)


