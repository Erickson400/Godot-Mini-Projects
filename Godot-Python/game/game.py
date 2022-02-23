from godot import exposed, export, ResourceLoader
from godot import *
from pymem import *


pm = Pymem("visualboyadvance-m.exe")


sides_address = 0x18E3B8D92C0
front_address = 0x18E3B8D92C8
vertical_address = 0x18E3B8D92C4

@exposed
class game(Node):
	
	def _ready(self):
		self.mynode = self.get_node("MyNode")
	
	
	def move_up(self, speed):
		position = pm.read_int(vertical_address)
		pm.write_int(vertical_address, position+speed)
	def move_down(self, speed):
		position = pm.read_int(vertical_address)
		pm.write_int(vertical_address, position-speed)
	
	def move_forward(self, speed):
		position = pm.read_int(front_address)
		pm.write_int(front_address, position+speed)
	def move_backward(self, speed):
		position = pm.read_int(front_address)
		pm.write_int(front_address, position-speed)
			
	def move_left(self, speed):
		position = pm.read_int(sides_address)
		pm.write_int(sides_address, position-speed)
	def move_right(self, speed):
		position = pm.read_int(sides_address)
		pm.write_int(sides_address, position+speed)
		
