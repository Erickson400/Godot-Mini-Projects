extends Node




func _ready():
	randomize()
	var food_scn = load("res://game/entities/food/food.tscn")
	for i in 10:
		var food_inst = food_scn.instance()
		food_inst.position = Vector2(randf()*1000, randf()*600)
		add_child(food_inst)
	
	
	
