extends Area3D


func _process(_delta):
	$Label3D.text = "Cash to Collect: " + str(Game.cash_to_collect)


func _on_body_entered(body):
	if body.is_in_group("player"):
		Game.cash += Game.cash_to_collect
		Game.cash_to_collect = 0
		
