extends MeshInstance3D

var color: int

func _ready():
	color = ColorDatabase.create_new_color_id(self)
