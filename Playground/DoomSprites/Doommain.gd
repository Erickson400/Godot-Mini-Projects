extends Node2D

var thread:Thread
export(StreamTexture) var stream_texture
var image:Image
var transformed_image:Image
var image_texture:ImageTexture

func _ready():
	thread = Thread.new()
	image = stream_texture.get_data()
	transformed_image = Image.new()
	transformed_image.create(OS.get_screen_size().x, OS.get_screen_size().y, false, Image.FORMAT_RGBA8)
	
	var num = 1.075

	var smooth = smoothstep(-2, 2, num)
	smooth *= 2
	smooth -= 1
	print(smooth)
	
	####
# warning-ignore:return_value_discarded
	thread.start(self, "thread_func", null)
	
	print("Loading")
	yield(get_tree().create_timer(5), "timeout")
	print("Finished Loading")
	thread.wait_to_finish()
	
	####
	
	
	image_texture = ImageTexture.new()
	image_texture.create_from_image(transformed_image)
	$Screen.texture = image_texture

func thread_func(_data):
	transformed_image.lock()
	image.lock()
	
	for x in range(0, 64, 1):
		for y in range(0, 64, 1):
			transformed_image.set_pixel(x+(y*(y*-0.005)), y, image.get_pixel(x,y)) #image.get_pixel(x,y) Color.red
			
	transformed_image.unlock()
	image.unlock()
	









func _exit_tree():
	if thread.is_active():
		thread.wait_to_finish()







