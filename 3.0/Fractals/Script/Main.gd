extends Spatial

var sierpinski_pyra_scn = preload("res://Script/Class_Sierpinski_pyra.gd")
var sierpinski_sponge_scn = preload("res://Script/Class_Menger_sponge.gd")
var pyra2_scn = preload("res://Script/Class_Equilateral_Pyra.gd")

var thread:Thread

func _ready():
	thread = Thread.new()
	thread.start(self, "Load_Fractal", null, 1)

func Load_Fractal(arg):
	#var sponge_inst = sierpinski_sponge_scn.new(3, 0.5)
	#add_child(sponge_inst)
	
	var pyra_inst = sierpinski_pyra_scn.new(6, 0.5)
	add_child(pyra_inst)
	pyra_inst.rotate_y(deg2rad(90))
	
	var pyra2_inst = pyra2_scn.new(6, 0.5)
	add_child(pyra2_inst)
	
	#pyra2_inst.translate(Vector3(30,0,0))






func _exit_tree():
	thread.wait_to_finish()








	
