extends Node


@onready var sub: SubViewport = $Sub
const CUBE = preload("res://cube.tscn")

var some_id = null

func _ready():
	sub.size = get_viewport().size
	
	# Create cubes
	for z in 100:
		for x in 100:
			var cube = CUBE.instantiate()
			cube.position = Vector3(-x*2, 0, -z*2)
			$Cubes.add_child(cube)
			
	# Create color meshes
	for c in $Cubes.get_children():
		var instance = MeshInstance3D.new()
		instance.transform = c.transform
		instance.mesh = BoxMesh.new()
		var material_duplicate = preload("res://material.tres").duplicate()
		instance.mesh.surface_set_material(0, material_duplicate)
		instance.mesh.surface_get_material(0).set_shader_parameter("color", Color(c.color))
		instance.set_layer_mask_value(1, false)
		instance.set_layer_mask_value(2, true)
		$Sub/Cubes.add_child(instance)
	

func _process(delta):
	sub.size = get_viewport().size
	#$Camera3D.global_rotate(Vector3.UP, 1*delta)
	$Sub/Camera3D.transform = $Camera3D.transform
	


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var image := sub.get_texture().get_image()
			var mouse_position := get_viewport().get_mouse_position()
			var clicked_color = image.get_pixelv(mouse_position)
			$Result.modulate = clicked_color
			var clicked_node = ColorDatabase.get_node_with_color_id(clicked_color.to_rgba32())
			if clicked_node:
				print("Clicked: ", clicked_node.name)
				print(clicked_node.get_instance_id())
				some_id = clicked_node.get_instance_id()
			image.save_png("user://screenshot.png")

	if Input.is_action_just_pressed("ui_down"):
		var node = instance_from_id(some_id)
		print(node)

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
