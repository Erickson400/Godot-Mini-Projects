extends Node

var coin_scn = preload("res://Scenes/Coin.tscn")
var thread1

func _ready():
	randomize()
	
	thread1 = Thread.new()
	thread1.start(self, "threadFunc", null)


func threadFunc(_thread_arg):
	for n in 2000:
		var coin_inst = coin_scn.instance()
		add_child(coin_inst)
		coin_inst.translate(Vector3(rand_range(-100,100), rand_range(0,20), rand_range(-100,100)))
	
func _exit_tree():
	thread1.wait_to_finish()

