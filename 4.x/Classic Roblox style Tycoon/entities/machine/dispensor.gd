extends Node3D


const TIME_RANGE = [0.2, 5]
@export var automatic = true

@onready var token_scn = preload("res://entities/machine/token.tscn")


func _enter_tree():
	$SpawnRate.autostart = automatic
	$SpawnRate.wait_time = randf_range(TIME_RANGE[0], TIME_RANGE[1])


func spawn_token():
	if visible:
		var inst = token_scn.instantiate()
		add_child(inst)


func _on_spawn_rate_timeout():
	spawn_token()
	$SpawnRate.wait_time = randf_range(TIME_RANGE[0], TIME_RANGE[1])




