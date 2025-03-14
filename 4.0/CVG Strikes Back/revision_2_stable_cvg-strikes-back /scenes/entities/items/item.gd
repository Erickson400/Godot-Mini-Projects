extends AnimatedSprite2D

# State 0 - inactive
# State 1 - going up and towards the facing direction
# State 2 - going up and towards the facing direction
enum State {GOING_UP, GOING_DOWN}

# "cash", "computers", "teachers"
var type: String = "cash"
var state: int = State.GOING_UP
var move_right: bool = true


func _process(_delta: float) -> void:
	match type:
		"cash":
			frame = 0
		"computers":
			frame = 1
		"teachers":
			frame = 2
		_:
			push_error(type+" is not an item")
	
	position.x += 2 if move_right else -2
	if state == State.GOING_UP:
		position.y -= 5
		if position.y < 280:
			state = State.GOING_DOWN
			
	elif state == State.GOING_DOWN:
		position.y += 4
		if position.y > 450:
			queue_free()
	
