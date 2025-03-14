extends Node
class_name State_Machine

var history = [] # Holds strings of the state names
var Active_State





func _ready(): 
	# Print an Error if States have no Script
	for child in get_children():
		if child.get_script() == null:
			push_error("State %s has no Script" % child.name)
	
	Active_State = get_child(0)
	_enter_state()
	
func change_to(new_state:String):
	history.append(Active_State.name)
	Active_State = get_node(new_state)
	_enter_state()
	
func back(): # gets the previous state
	if history.size() > 0:
		Active_State = get_node(history.pop_back())
		_enter_state()

func _enter_state():
	# Give the new state a reference to this state machine script
	Active_State.Finite_sm = self
	Active_State._begin()

func _physics_process(delta):
	if Active_State.has_method("physics_process"):
		Active_State.physics_process(delta)














