extends Node2D


const SPEED = 800
var damage := 1


func _process(delta):
	translate(global_transform.x * SPEED * delta)


func _on_despawn_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("terrain"):
		queue_free()
