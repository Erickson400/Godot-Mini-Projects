from godot import exposed, export, ResourceLoader
from godot import *
from pymeow import *

## ----------------HOW POINTERS WORK-------------------
## The Addresses and pointers should be in 64 bit.
## The pointer's base address is the module's address plus it's main offset. (ex. VGA+0x0383A0B0)
## The first offset is added to the value of the pointer's base address.
##
## VGA+0x0383A0B0 -> 0x1A29B36E59C this is the value that address holds
## 0x1A29B36E59C + 0x5EFC -> Health this is the value that address holds
##


process = process_by_name("pcsx2.exe")

health_base_address = process["modules"]["pcsx2.exe"]["baseaddr"]+0x0383A0B0
offsets = [0x5EFC]

front_address = 0x207FEAB8
sides_address = 0x207FEABC
vertical_address = 0x207FEAC0

@exposed
class game(Node):
	
	def _ready(self):
		self.nd = self.get_node("MyNode")
		self.sus = 23
		

		
	def _process(self, delta):
		pass
#		base_value = read_uint64(process, health_base_address)
#
#		health_address = base_value + offset
#
#		health_value = read_float16(process, health_address)
#
#		self.nd.set_health(health_value)
		#print(self.nd.hex(health_value))
		
		
		
	def read_offsets(proc, base_address, offset):
		base_point = read_float64(proc, base_address)
		
		current_pointer = base_point
		
		for i in offsets[:-1]:
			current_pointer = read_float64(proc, current_pointer+i)
			
		return current_pointer + offsets[-1]
	
	
	
	def move_up(self, speed):
		position = read_float(process, vertical_address)
		write_float(process, vertical_address, position+speed)
	def move_down(self, speed):
		position = read_float(process, vertical_address)
		write_float(process, vertical_address, position+speed)

	def move_forward(self, speed):
		position = read_float(process, front_address)
		write_float(process, front_address, position-speed)
	def move_backward(self, speed):
		position = read_float(process, front_address)
		write_float(process, front_address, position+speed)
			
	def move_left(self, speed):
		position = read_float(process, sides_address)
		write_float(process, sides_address, position+speed)
		
	def move_right(self, speed):
		position = read_float(process, sides_address)
		write_float(process, sides_address, position+speed)
	
	
