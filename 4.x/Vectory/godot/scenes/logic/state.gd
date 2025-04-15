class_name State extends Node

# Emit this signal in the run or input functions
# to transition, do not call exit() or enter().
signal transitioned_to(from: State, to: State)


func enter():
	pass


func exit():
	pass


@warning_ignore("unused_parameter")
func update(delta: float):
	pass


@warning_ignore("unused_parameter")
func input(event: InputEvent):
	pass
	
	
	
