extends Node

var max_range = 10

var Top_num = 0
var Bottom_num = 0
var Result = 0

var textb = ""

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			var string_key = OS.get_scancode_string(event.scancode)
			
			#Enter
			if event.scancode == KEY_ENTER:
				Result = textb.to_int()
				
				if Result == Top_num + Bottom_num:
					correct()
				else:
					wrong()
					
				generate()
				textb = ""
			#Backspace
			if event.scancode == KEY_BACKSPACE:
				textb.erase(textb.length()-1, 1)
			#Number
			var number = string_key.to_int()
			if number == 0 and event.scancode != 48:
				return
			textb += String(number)



func _ready():
	generate()


func _process(_delta):
	if textb.length() > 3:
		textb.erase(textb.length()-1, 1)
	$TextBox.text = textb




func generate():
	randomize()
	Top_num = round(rand_range(1, max_range))
	Bottom_num = round(rand_range(1, max_range))
	$Top.text = String(Top_num)
	$Bottom.text = String(Bottom_num)






func correct():
	$Flash.start()
	$bar.color = Color.green	
func wrong():
	$Flash.start()
	$bar.color = Color.red
func _on_Flash_timeout():
	$bar.color = Color.white
