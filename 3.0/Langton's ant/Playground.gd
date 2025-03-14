extends Node

var thread:Thread

func _ready():
	thread = Thread.new()
	thread.start(self, "thread_func", null)
	
func _exit_tree():
	thread.wait_to_finish()




func thread_func(thread_data = null):
	var start_time = OS.get_ticks_msec()
	
	print(gridTraveler(10, 10))
	
	var end_time = OS.get_ticks_msec()
	print("Lasted: ", end_time-start_time, "ms")




func gridTraveler(m, n, memo={}) -> int:
	var key = m + n
	if key in memo: return memo[key]
	
	if m == 0 or n == 0: return 0
	if m == 1 or n == 1: return 1
	
	memo[key] = gridTraveler(m-1, n, memo) + gridTraveler(m, n-1, memo)
	return memo[key]
	
	
