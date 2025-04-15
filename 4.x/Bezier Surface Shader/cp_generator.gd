@tool
extends Node

func _enter_tree():
	for n in get_children():
		n.queue_free()
	
	await get_tree().create_timer(0.1).timeout
	
	for z in range(4):
		for x in range(4):
			var position3D = Marker3D.new()
			add_child(position3D)
			position3D.name = "cp"+str(z*x)
			position3D.set_owner(get_tree().edited_scene_root)
			position3D.global_position = Vector3(x, 0, z)
