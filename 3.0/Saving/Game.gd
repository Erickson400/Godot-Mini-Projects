extends Node

var money = 100

func _process(delta):
	$Money.text = "Money; " + str(money)

func _on_Save_pressed():
	var file = File.new()
	file.open("user://money.sav", File.WRITE)
	file.store_var(money)
	file.close()
	
func _on_Load_pressed():
	var file = File.new()
	if file.file_exists("user://money.sav"):
		file.open("user://money.sav", File.READ)
		money = file.get_var()
		file.close()
	else:
		print("There is no file to load")

func _on_add_pressed():
	money += 1
func _on_sub_pressed():
	money -= 1
