extends Control


func _process(delta: float) -> void:
	var node = $Mode
	if ModeManager.mode == ModeManager.Mode.PATCH_SELECT:
		node.text = "Node: Patch Select"
	elif ModeManager.mode == ModeManager.Mode.PATCH_EDIT:
		node.text = "Node: Patch Edit"
	elif ModeManager.mode == ModeManager.Mode.CORNER_SELECT:
		node.text = "Node: Corner Select"
	elif ModeManager.mode == ModeManager.Mode.CORNER_EDIT:
		node.text = "Node: Corner Edit"	
