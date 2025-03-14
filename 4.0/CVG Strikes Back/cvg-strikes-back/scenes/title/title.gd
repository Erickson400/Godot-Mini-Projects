extends Node2D

var key_timer: int = 0

@onready var enter: Label = $Enter as Label


func _ready() -> void:
	GlobalTheme.play()


func _process(_delta: float) -> void:
	enter.label_settings.font_color = Color(1, randf(), 0)
	
	key_timer += 1
	if Input.is_action_just_pressed("Quit") and key_timer > 20:
		get_tree().quit()
	if Input.is_action_just_pressed("Enter"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

	const PITCH_SHIFT: float = 0.05
	if Input.is_action_just_pressed("Left"):
		GlobalTheme.pitch_scale -= PITCH_SHIFT
	if Input.is_action_just_pressed("Right"):
		GlobalTheme.pitch_scale += PITCH_SHIFT
