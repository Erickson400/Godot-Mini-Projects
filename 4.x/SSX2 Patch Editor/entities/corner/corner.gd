class_name Corner
extends Marker3D
## Holds the position of a patch's potential corner control point.


## The 4 control points located around the X and Z axis of the corner.
## The handles follow the tranformation of the corner.
@onready var handle: Dictionary = {
	"-X": $"-X",
	"+X": $"+X",
	"-Z": $"-Z",
	"+Z": $"+Z",
}


func get_opposite(handle_name: String) -> Node3D:
	assert(handle_name in handle.keys(), "Invalid handle name")
	match handle_name:
		"-X":
			return $"+X"
		"+X":
			return $"-X"
		"-Z":
			return $"+Z"
		"+Z":
			return $"-Z"
		_:
			return null
