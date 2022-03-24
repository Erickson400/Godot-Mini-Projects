extends Area2D


var hunger:float = 100





var touched_food = false


func _ready():
	$ProgressBar.value = hunger


func _process(_delta):
	$Utility.scores["hunger"] = hunger/100




func _on_Hunger_timeout():
	hunger -= 1
	$ProgressBar.value = hunger
func _on_Player_area_entered(area):
	touched_food = true
	hunger += 50
	$ProgressBar.value = hunger


func _on_evaluate_timeout():
	$Utility.evaluate()
