extends Node


onready var active_cam = $Level/Camera

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		$Blink/AnimationPlayer.play("BlinkClose")
		#print("SUSsss")


func closed_eyes():
	$Blink/AnimationPlayer.play("BlinkOpen")
	if active_cam == $Level/Camera:
		active_cam = $Level/Camera2
		active_cam.current = true
	else:
		active_cam = $Level/Camera
		active_cam.current = true



func _ready():
	#print(OS.get_executable_path().get_base_dir())
	var outputs = []
	var exit_code = OS.execute(OS.get_executable_path()+"test.exe", [], true, outputs)
	
	print(exit_code)
	print(outputs)







	
