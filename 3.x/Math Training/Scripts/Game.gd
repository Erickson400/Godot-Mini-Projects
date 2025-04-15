extends Node

var min_range = 0#100_000
var max_range = 10_000_000

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
				
				if Result == Top_num - Bottom_num:
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
	if textb.length() > 9:
		textb.erase(textb.length()-1, 1)
	
	var num = textb.to_int()
	var string = comma_sep(num)
	$TextBox.text = string




func generate():
	randomize()
	Top_num = round(rand_range(min_range, max_range))
	Bottom_num = round(rand_range(min_range, Top_num))
	#Top_num = round(rand_range(10, 20))
	#Bottom_num = round(rand_range(0, 10))
	
	
	$Top.text = comma_sep(Top_num)
	$Bottom.text = comma_sep(Bottom_num)




func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res
	
	

func correct():
	$Flash.start()
	$bar.color = Color.green	
func wrong():
	$Flash.start()
	$bar.color = Color.red
func _on_Flash_timeout():
	$bar.color = Color.white
