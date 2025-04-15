extends Node2D


var state: int = Global.PointState.FREE :
	set(value):
		match value:
			Global.PointState.SELECTED:
				$Border.visible = true
				$Border.modulate = Color(0.3, 0.3, 0.3, 0.4)
			Global.PointState.MOVING:
				$Border.visible = true
				$Border.modulate = Color(0.8, 0, 0, 0.3)
			Global.PointState.FREE :
				$Border.visible = false
			_:
				push_error("Point State: %s does not exist.")
				return
		state = value

var last_position = position 

	





