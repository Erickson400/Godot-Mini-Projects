extends Node


var database: Dictionary = {}


func get_node_with_color_id(id: int) -> Node:
	return database[id] if database.has(id) else null


func create_new_color_id(node_reference: Node):
	# Returns the color id
	var rand_color: int
	while true:
		rand_color = _rand_color8_id()
		if database.has(rand_color):
			continue
		else:
			break
	database[rand_color] = node_reference
	#print("Created id for ", node_reference, " id: ", rand_color)
	return rand_color


func _rand_color8_id() -> int:
	return Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255)).to_rgba32()
