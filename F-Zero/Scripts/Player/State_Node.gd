extends Node
class_name State_Node

var Finite_sm
onready var Player:KinematicBody = get_parent().get_parent()

func _begin():
	pass

func _end(nest_state): 
	# Call when want to exit.
	# If you want to stop Executing right away 
	# return after calling _end.
	
	Finite_sm.change_to(nest_state)
	
func physics_process(delta):
	return delta
	


