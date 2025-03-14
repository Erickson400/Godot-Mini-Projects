extends Node




var speed = 0.001


func _ready():
	$SpeedEdit.text = str(speed)
	

	

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_pressed("ui_left"):
		get_parent().move_left(speed)
	if Input.is_action_pressed("ui_right"):
		get_parent().move_right(speed)
		
	if Input.is_action_pressed("ui_up"):
		get_parent().move_forward(speed)
	if Input.is_action_pressed("ui_down"):
		get_parent().move_backward(speed)
		
	if Input.is_action_pressed("ui_page_up"):
		get_parent().move_up(speed)
	if Input.is_action_pressed("ui_page_down"):
		get_parent().move_down(speed)
		
func hex(num):
	return "0x%X" % num

func set_health(num):
	$Health.text = str(num)

func _on_SpeedEdit_text_changed():
	speed = int($SpeedEdit.text)
