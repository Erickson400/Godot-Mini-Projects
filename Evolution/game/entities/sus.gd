extends Object
class_name sus


func _init():
	print("created")
	
func test():
	var sss = get_script().new()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		print("deleted")

