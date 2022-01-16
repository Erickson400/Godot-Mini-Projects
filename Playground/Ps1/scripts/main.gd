extends Spatial


export(String, FILE) var res_path
var my_res = null



func _ready():
	my_res = load(res_path)
	assert(my_res == null, "Could not load resource")
	








