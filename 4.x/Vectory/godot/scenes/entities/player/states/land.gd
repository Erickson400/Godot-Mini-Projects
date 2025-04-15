extends State


@export var character: CharacterBody2D
@export var fly_state: State
@export var front_propeller: Node3D
@export var tilt_pivot: Node3D

@onready var propeller_speed = character.PROPELLER_SPEEDS["down"]


func enter():
	propeller_speed = character.PROPELLER_SPEEDS["down"]
	character.velocity = Vector2.ZERO

func update(delta):
	propeller_speed *= 0.99
	front_propeller.rotate_y(propeller_speed * delta)
	tilt_pivot.rotation.x = lerpf(tilt_pivot.rotation.x, 0, 10 * delta)


func input(event):
	if event.is_action_pressed("Up"):
		transitioned_to.emit(self, fly_state)
	



