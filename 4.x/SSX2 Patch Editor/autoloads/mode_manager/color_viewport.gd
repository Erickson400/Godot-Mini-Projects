extends SubViewport


@export var color_material: StandardMaterial3D = null

var main_vewport: Viewport = null

## Color : Patch_Reference
var _color_database: Dictionary = {}
## Patch_Reference : Color
var _patch_database: Dictionary = {}

@onready var sub_camera: Camera3D = $Camera3D


func _process(delta: float) -> void:
	assert(main_vewport, "Manager didnt set the main_viewport")
	sub_camera.global_transform = main_vewport.get_camera_3d().global_transform
	size = main_vewport.size
	

func _rand_color() -> Color:
	return Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255))


func add_mesh_to_select_buffer(patch: Patch, mesh: Mesh):
	if patch in _patch_database:
		var mesh_instance = get_node(NodePath(patch.name))
		mesh_instance.mesh = mesh
		return

	var rand_color: Color
	while true:
		rand_color = _rand_color()
		if _color_database.has(rand_color):
			continue
		else:
			break
	_color_database[rand_color] = patch
	_patch_database[patch] = rand_color

	var instance := MeshInstance3D.new()
	instance.name = patch.name
	instance.mesh = mesh
	instance.material_override = color_material.duplicate()
	instance.material_override.albedo_color = rand_color
	instance.set_layer_mask_value(1, false)
	instance.set_layer_mask_value(2, true)
	add_child(instance)
	instance.global_position = patch.global_position


func get_patch_on_mouse_position(debug_visualizer: bool = false) -> Node3D:
	var image: Image = get_texture().get_image()
	if debug_visualizer:
		image.save_png("user://screenshot.png")
		
	var mouse_position: Vector2 = main_vewport.get_mouse_position()
	var clicked_color: Color = image.get_pixelv(mouse_position)
	return _color_database.get(clicked_color)
