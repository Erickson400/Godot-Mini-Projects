extends Camera

func _process(_delta):
	
	# Size of raycast
	var ray_length = 2000 
	
	# Mouse Position on screen
	var Mouse_Pos = get_viewport().get_mouse_position()
	
	# end point of ray (global)
	var ray_End = project_ray_normal(Mouse_Pos) * ray_length
	
	# Set the raycast cast to end point
	$RayCast.cast_to = to_local(ray_End)

	if Input.is_action_just_pressed("Click"):
		
		# get raycast collision object
		var collider = $RayCast.get_collider()
		
		
		# did it collide?
		if collider:
			var point_pos = $RayCast.get_collision_point()
			print(point_pos)
			
			var meshInstance = MeshInstance.new()
			meshInstance.translation = point_pos
			meshInstance.mesh = SphereMesh.new()
			
			get_parent().get_parent().add_child(meshInstance)
			
			
			
			
			
			
			
			
			
			
	
	
	
