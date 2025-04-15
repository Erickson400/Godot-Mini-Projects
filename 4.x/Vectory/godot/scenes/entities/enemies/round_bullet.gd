extends Area2D


const GRAVITY = 2
var velocity = Vector2.ZERO


func _ready():
	$MeshInstance2D.scale = Vector2(20,20)
	$CollisionShape2D.shape.radius = 3


func _process(delta):
	velocity.y += GRAVITY
	translate(velocity * delta)


func _on_despawn_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("terrain"):
		queue_free()


func enable_big_bullet():
	$MeshInstance2D.scale = Vector2(50,50)
	$CollisionShape2D.shape.radius = 8
