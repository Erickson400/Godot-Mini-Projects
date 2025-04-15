extends Control


func _process(_delta):
	$Label.text = "Cash: " + str(Game.cash)
	

