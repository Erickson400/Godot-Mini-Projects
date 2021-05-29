extends Spatial

var rock_scn = preload("res://Scenes/Rock.tscn")

var spawn_range = Vector2(-30, 30)












func _on_Spawn_Rate_timeout():
	var rock_inst = rock_scn.instance()
	rock_inst.translation = Vector3(rand_range(spawn_range.x, spawn_range.y),0,0)
	add_child(rock_inst)


