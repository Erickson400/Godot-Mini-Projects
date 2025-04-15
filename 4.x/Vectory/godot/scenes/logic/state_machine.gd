class_name StateMachine extends Node


var active_state: State


func _ready():
	for c in get_children():
		c.transitioned_to.connect(_on_state_transition)
	
	active_state = get_child(0)
	active_state.enter()


func _process(delta):
	active_state.update(delta)


func _unhandled_input(event):
	active_state.input(event)


func _on_state_transition(from: State, to: State):
	active_state = to
	from.exit()
	to.enter()



