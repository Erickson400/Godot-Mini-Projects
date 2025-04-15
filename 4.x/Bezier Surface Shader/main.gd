@tool
extends Node

func _process(_delta):
	var get_position = func(x):
		return x.global_position
	
	var positions = $"Control Points".get_children().map(get_position)
	$Surface.mesh.surface_get_material(0).set_shader_parameter("control_points", positions)
	
	
