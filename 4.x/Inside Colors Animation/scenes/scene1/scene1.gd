extends Node3D


#func _ready():
#	$AnimationTree.process_callback = AnimationTree.ANIMATION_PROCESS_IDLE


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		$AnimationTree.process_callback = AnimationTree.ANIMATION_PROCESS_IDLE
