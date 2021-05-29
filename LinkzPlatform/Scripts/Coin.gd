extends Area


func _process(delta):
	rotate_y(deg2rad(100 * delta))


func _on_Coin_body_entered(body):
	if body.name == "Player":
		body.get_node("HUD").add_label_coins()
		queue_free()
