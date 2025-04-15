extends Node




func _on_far_dist_value_changed(value):
	GameBus.val1 = value

func _on_far_size_value_changed(value):
	GameBus.val2 = value
#
#func _on_near_dist_value_changed(value):
#	GameBus.near_plane.distance = value
#
#func _on_near_size_value_changed(value):
#	GameBus.near_plane.size = value
