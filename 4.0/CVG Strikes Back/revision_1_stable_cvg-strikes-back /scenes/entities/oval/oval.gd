extends Node2D


var color: Color = Color.RED


func _draw() -> void:
	draw_circle(Vector2(), 5, color, false)


func _process(_delta: float) -> void:
	queue_redraw()
