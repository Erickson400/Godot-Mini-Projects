extends CharacterBody2D


signal moved(new_pos:Vector2)

const PROPELLER_SPEEDS = {
	"up": 20.0,
	"idle": 10.0,
	"down": 5.0,
	"landed": 0.0,
}


func enable_landing():
	if $StateMachine.active_state.name == "Fly":
		$StateMachine.active_state.enable_landing()

	
