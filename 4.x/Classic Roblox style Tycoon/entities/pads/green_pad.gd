extends StaticBody3D


signal pressed

@onready var material = $MeshInstance3D.get_active_material(0) as StandardMaterial3D


func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and $Cooldown.is_stopped():
		$Cooldown.start()
		pressed.emit()
		material.albedo_color = Color.RED


func _on_cooldown_timeout():
	material.albedo_color = Color.GREEN
