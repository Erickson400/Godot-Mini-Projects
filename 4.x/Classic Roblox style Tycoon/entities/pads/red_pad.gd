@tool
extends StaticBody3D

@export_enum("Buy", "Upgrade") var type = "Buy"
@export var segment_name : String
@export var price = 0

signal pressed

func _enter_tree():
	if Engine.is_editor_hint():
		set_process(true)
	else:
		_setup_label()

func _process(_delta):
	_setup_label()

func _setup_label():
	var free_check = "Free" if price == 0 else str(price)
	$Label3D.text = "%s %s -%s-" % [type, segment_name, free_check]


func _on_area_3d_body_entered(body):
	if body.is_in_group("player") and visible:
		if Game.cash >= price:
			Game.cash -= price
			pressed.emit()
			queue_free()
			




