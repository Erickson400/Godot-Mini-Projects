extends Area



func _on_Jump_Pad_body_entered(body):
	if body.name == "Player":
		body.Jump()
