extends Node

const SIZE = 80



func _ready():
	initialize_raycasts()

func _process(_delta):
	return
	print(Engine.get_frames_per_second())

func _unhandled_input(event):
	if Input.is_action_just_pressed("click"):
		update_image()
			




func update_image():
	var image = Image.new()
	image.create(SIZE, SIZE, false, Image.FORMAT_RGB8)
	
	var ray_index = 0
	image.lock()
	for y in SIZE:
		for x in SIZE:
			var ray:RayCast = $Camera.get_child(ray_index)
			if ray.is_colliding():
				var collider = ray.get_collider()
				# Get the color
				var surface_color:Color = Color.white
				if collider.is_in_group("ball"):
					surface_color = Color.red
				
				# SpotLight
				var dist = ray.get_collision_point().distance_squared_to($Light.global_transform.origin)
				if dist < 5:
					surface_color = Color.green
				
				# Directional light
				var light = Vector3(0, -1, -1).normalized()
				var normal = ray.get_collision_normal()
				surface_color = surface_color.darkened(light.dot(normal)*1.5)
				
				
				# Shadow
				var distShd = ray.get_collision_point().distance_squared_to($Ball.global_transform.origin)
				if distShd < 5:
					surface_color = surface_color.blend(Color.black*0.9)
					
				
				
				
				image.set_pixel(x,y,surface_color)
				
				
				
			ray_index+=1
	image.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(image, Texture.FLAG_REPEAT)
	$Screen/Sprite.texture = tex



func initialize_raycasts():
	var FOV = 80
	for x in range(-FOV/2, FOV/2, 1):
		for y in range(-FOV/2, FOV/2, 1):
			var ray = RayCast.new()
			ray.enabled = true
			ray.cast_to = Vector3(0,0,-100)
			ray.collide_with_areas = true
			ray.collide_with_bodies = false
			$Camera.add_child(ray)
			ray.rotate_y(deg2rad(y))
			ray.rotate_x(deg2rad(x))
		







