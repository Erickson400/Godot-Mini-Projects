extends Spatial

# If true then Main -> Out
# If false then Out -> Main
var b_turn = true 
var spawn_Pos = Vector3(0,0,0)
var b_isSand = true

func _process(delta):
	var speed = 20
	if Input.is_action_pressed("ui_up"):
		spawn_Pos.z -= speed*delta
	if Input.is_action_pressed("ui_left"):
		spawn_Pos.x -= speed*delta
	if Input.is_action_pressed("ui_down"):
		spawn_Pos.z += speed*delta
	if Input.is_action_pressed("ui_right"):
		spawn_Pos.x += speed*delta
	if Input.is_action_just_pressed("ui_select"):
		b_isSand = !b_isSand
		


func Iterate(node_A, node_B):
	
	for n in node_A.get_used_cells():
		# If on solid ground
		
		if n.y == 0:
			if get_cellv(node_A, n) == 0:
				set_cellv(node_B, n, 0)
				continue
			else:
				set_cellv(node_B, n, 1)
				continue
			
		# Side coordinates
		var below = n+Vector3(0,-1,0)
		var below_left = n+Vector3(-1,-1,0)
		var below_right = n+Vector3(1,-1,0)
		var below_forward = n+Vector3(0,-1,-1)
		var below_back = n+Vector3(0,-1,1)
		
		var middle_left = n+Vector3(-1,0,0)
		var middle_right = n+Vector3(1,0,0)
		var middle_forward = n+Vector3(0,0,-1)
		var middle_back = n+Vector3(0,0,1)
		
		if b_isSand:
			# Sand
			if get_cellv(node_A, below)<0:
				set_cellv(node_B, below, 0)
			elif get_cellv(node_A, below_left)<0:
				set_cellv(node_B, below_left, 0)
			elif get_cellv(node_A, below_right)<0:
				set_cellv(node_B, below_right, 0)
				
			elif get_cellv(node_A, below_forward)<0:
				set_cellv(node_B, below_forward, 0)
			elif get_cellv(node_A, below_back)<0:
				set_cellv(node_B, below_back, 0)

			else:
				set_cellv(node_B, n, 0)
		else:
			# Water
			if get_cellv(node_A, below)<0:
				set_cellv(node_B, below, 1)
			elif get_cellv(node_A, below_left)<0:
				set_cellv(node_B, below_left, 1)
			elif get_cellv(node_A, below_right)<0:
				set_cellv(node_B, below_right, 1)
				
			elif get_cellv(node_A, below_forward)<0:
				set_cellv(node_B, below_forward, 1)
			elif get_cellv(node_A, below_back)<0:
				set_cellv(node_B, below_back, 1)

			else:
				# cant move down
				if get_cellv(node_A, middle_left)<0:
					set_cellv(node_B, middle_left, 1)
				elif get_cellv(node_A, middle_right)<0:
					set_cellv(node_B, middle_right, 1)
				elif get_cellv(node_A, middle_forward)<0:
					set_cellv(node_B, middle_forward, 1)
				elif get_cellv(node_A, middle_back)<0:
					set_cellv(node_B, middle_back, 1)
				else:
					set_cellv(node_B, n, 1)
					continue
				
	node_A.clear()
	
func get_cellv(node:GridMap, pos:Vector3) -> int:
	return node.get_cell_item(pos.x, pos.y, pos.z)

func set_cellv(node:GridMap, pos:Vector3, value:int):
	return node.set_cell_item(pos.x, pos.y, pos.z, value)


func _on_Iterate_timeout():
	if b_turn:
		Iterate($MainGrid, $OutGrid)
		b_turn = false
		return
			
	if !b_turn:
		Iterate($OutGrid, $MainGrid)
		b_turn = true
		return

func _on_Spawner_timeout():
	var is_sand
	if b_isSand:
		is_sand = 0
	else:
		is_sand = 1
	
	
	$MainGrid.set_cell_item(spawn_Pos.x,20,spawn_Pos.z, is_sand)
	$MainGrid.set_cell_item(spawn_Pos.x-1,20,spawn_Pos.z-1, is_sand)
	$MainGrid.set_cell_item(spawn_Pos.x+1,20,spawn_Pos.z+1, is_sand)

	$MainGrid.set_cell_item(spawn_Pos.x+1,20,spawn_Pos.z-1, is_sand)
	$MainGrid.set_cell_item(spawn_Pos.x-1,20,spawn_Pos.z+1, is_sand)











