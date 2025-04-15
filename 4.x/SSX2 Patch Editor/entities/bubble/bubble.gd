extends Area3D


@onready var camera: Camera3D = get_viewport().get_camera_3d()
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _process(delta: float) -> void:
	var offset = 0.02
	var distance = global_position.distance_to(camera.global_position) * offset
	mesh_instance.look_at(camera.global_position, Vector3.UP, true)
	collision_shape.shape.radius = distance/2


func select():
	var material: ShaderMaterial = mesh_instance.material_override
	material.set_shader_parameter("inner_ring", 0.0)


func deselect():
	var material: ShaderMaterial = mesh_instance.material_override
	material.set_shader_parameter("inner_ring", 0.32)
