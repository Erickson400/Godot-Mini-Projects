extends Node


const BUBBLE_SHADER = preload("res://autoloads/bubble_manager/bubble.gdshader")
const BUBBLE_RADIUS = 15

var _lines_to_draw: Array = []

@onready var bubbles: Node = $Bubbles
@onready var lines_mesh_instance: MeshInstance3D = $Lines


func _process(delta: float) -> void:
	for bubble in bubbles.get_children():
		var cp = instance_from_id(bubble.get_meta("control_point_id"))
		bubble.visible = not MainCamera.get_camera().is_position_behind(cp.global_position)
		bubble.position = MainCamera.get_camera().unproject_position(cp.global_position)
	
	var lines_mesh := SurfaceTool.new() 
	lines_mesh.begin(Mesh.PRIMITIVE_LINES)
	lines_mesh.set_color(Color.GREEN)
	for line in _lines_to_draw:
		lines_mesh.add_vertex(line[0].global_position)
		lines_mesh.add_vertex(line[1].global_position)
	lines_mesh_instance.mesh = lines_mesh.commit()


##----Public----
func add_bubble(control_point: Node3D, draw_line_to: Node3D = null) -> void:
	var sprite := Sprite2D.new()
	bubbles.add_child(sprite)
	var image := Image.create_empty(BUBBLE_RADIUS * 2,BUBBLE_RADIUS * 2, false, Image.FORMAT_RGBA8)
	sprite.texture = ImageTexture.create_from_image(image)
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = BUBBLE_SHADER
	sprite.set_meta("control_point_id", control_point.get_instance_id())
	if draw_line_to:
		_lines_to_draw.append([control_point, draw_line_to])
	

func clear_bubbles():
	for bubble in bubbles.get_children():
		bubble.queue_free()
	_lines_to_draw.clear()
	lines_mesh_instance.mesh = null


func get_bubble_sprite_on_mouse() -> Sprite2D:
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var bubbles_on_mouse = []
	for bubble in bubbles.get_children():
		if (bubble as Sprite2D).position.distance_to(mouse_position) < BUBBLE_RADIUS:
			bubbles_on_mouse.append(bubble)
	
	if bubbles_on_mouse.is_empty():
		return null
	if bubbles_on_mouse.size() == 1:
		return bubbles_on_mouse[0]
	
	# sort based on distance from camera plane
	var sort = func(a, b):
		var a_cp = instance_from_id(a.get_meta("control_point_id"))
		var b_cp = instance_from_id(b.get_meta("control_point_id"))
		var a_distance = MainCamera.get_distance_from_camera_plane(a_cp.global_position)
		var b_distance = MainCamera.get_distance_from_camera_plane(b_cp.global_position)
		if a_distance < b_distance:
			return true
		return false
	
	bubbles_on_mouse.sort_custom(sort)
	return bubbles_on_mouse[0]
	

func get_cp_from_bubble(bubble: Sprite2D) -> Node3D:
	return instance_from_id(bubble.get_meta("control_point_id"))


func select_by_cp(control_point: Node3D):
	for bubble in bubbles.get_children():
		if instance_from_id(bubble.get_meta("control_point_id")) == control_point:
			if bubble is Sprite2D:
				bubble.material.set_shader_parameter("inner_ring", 0.0)
				return
	assert(false, "control_point does not exist in bubble database")


#func deselect_by_cp(control_point: Node3D):
	#for bubble in bubbles.get_children():
		#if instance_from_id(bubble.get_meta("control_point_id")) == control_point:
			#if bubble is Sprite2D:
				#bubble.material.set_shader_parameter("inner_ring", 0.32)
				#return
	#assert(false, "control_point does not exist in bubble database")


func select_by_bubble_sprite(bubble: Sprite2D):
	bubble.material.set_shader_parameter("inner_ring", 0.0)


func deselect_all():
	for bubble in bubbles.get_children():
		bubble.material.set_shader_parameter("inner_ring", 0.32)
