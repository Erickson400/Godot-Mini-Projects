extends Action


func start():
	print(OS.get_ticks_msec(), " on idle")

func tick(delta):
	print(OS.get_ticks_msec(), " ideling")



