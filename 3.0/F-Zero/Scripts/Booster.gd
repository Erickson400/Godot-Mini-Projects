extends Area

func _on_Booster_body_entered(body):
	if body.name == "Player":
		body.get_node("Timer_Boost").start()
		body.MAX_SPEED = 80
	

