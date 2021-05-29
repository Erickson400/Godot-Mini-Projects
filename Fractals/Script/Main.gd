extends Spatial

var sierpinski_pyra_scn = preload("res://Script/Class_Sierpinski_pyra.gd")
var sierpinski_sponge_scn = preload("res://Script/Class_Menger_sponge.gd")


func _ready():
	
	var thread = Thread.new()
	
	thread.start(self, "Load_Fractal", null, 1)

	
	

func Load_Fractal(arg):
	var sponge_inst = sierpinski_sponge_scn.new(3, 0.5)
	add_child(sponge_inst)
	var pyra_inst = sierpinski_pyra_scn.new(6, 0.5)
	add_child(pyra_inst)
	pyra_inst.rotate_y(deg2rad(90))
	#pyra_inst.translate(Vector3(30,0,0))
	
