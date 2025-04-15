extends RigidBody3D


var level = 1


func _physics_process(delta):
	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("belt"):
			apply_central_force(body.direction * 50 * delta)
			break


func increase_level():
	level += 1
	var material = $MeshInstance3D.get_active_material(0) as StandardMaterial3D
	material.albedo_color.g8 -= 85
	material.albedo_color.b8 -= 85


func _on_area_3d_area_entered(area):
	if area.is_in_group("seller"):
		Game.cash_to_collect += Game.TOKEN_PRICE * level
		queue_free()
	
	if area.is_in_group("refiner") and area.visible:
		increase_level()
		print(232)
