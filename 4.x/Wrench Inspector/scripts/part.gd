extends StaticBody3D

var active = false

func _ready():
	self.input_event.connect(_on_input_event)

func disable():
	for c in get_children():
		if c is CollisionShape3D:
			c.disabled = true
		if c is MeshInstance3D:
			c.transparency = 0.9
			
func enable():
	for c in get_children():
		if c is CollisionShape3D:
			c.disabled = false
		if c is MeshInstance3D:
			c.transparency = 0

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("Click") and not active:
			active = true
			Bus.emit_signal("focus_camera", self.global_position)
			
			for c in get_parent().get_children():
				if c == self:
					continue
				if c is StaticBody3D:
					c.disable()

func _unhandled_input(event):
	if active:
		if event is InputEventKey:
			if event.is_action_pressed("Space"):
				active = false
				Bus.emit_signal("focus_camera", Vector3.ZERO)
				
				for c in get_parent().get_children():
					if c == self:
						continue
					if c is StaticBody3D:
						c.enable()
						

