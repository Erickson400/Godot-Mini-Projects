extends Action


func start():
	print(OS.get_ticks_msec(), " on food")

func tick(delta):
	print(OS.get_ticks_msec(), " finding food")





