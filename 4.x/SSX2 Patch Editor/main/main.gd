extends Node


func _ready() -> void:
	$WorldEnvironment.queue_free()
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_UNSHADED
	
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		get_tree().quit()
		
