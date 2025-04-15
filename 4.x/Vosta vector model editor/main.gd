extends Node2D
## Handles input
## Handles selection system
## Handles point move and extrude modes
## Creates/Delete Points
## Creates/Delete Edges

enum EditMode {
	FREE,
	MOVE,
	EXTRUDE,
}

var Point = preload("res://entities/point.tscn")
var _last_mouse_pos := Vector2.ZERO
var _drawing_select_box := false
var _select_rect := Rect2()
var _edit_mode := EditMode.FREE 

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Update SelectBox Rendering 
		if _drawing_select_box:
			$SelectBox.position = (_last_mouse_pos).snapped(Global.SNAP_RANGE)
			$SelectBox.scale = (get_global_mouse_position() - _last_mouse_pos).snapped(Global.SNAP_RANGE)
			_select_rect = Rect2($SelectBox.position, $SelectBox.scale).abs()
		
		# Update selected point positions in MOVE edit mode
		if _edit_mode == EditMode.MOVE:
			var sub = _last_mouse_pos - get_global_mouse_position()
			for p in $EdgeMesh.get_children():
				if p.state == Global.PointState.MOVING:
					p.position = (p.last_position - sub).snapped(Global.SNAP_RANGE)
			$EdgeMesh.update_mesh()
	
	if event.is_action_pressed("Exit"):
		get_tree().quit()
		
	# Select Box
	if event.is_action_pressed("Select") and _edit_mode == EditMode.FREE:
		_drawing_select_box = true
		$SelectBox.visible = true
		$SelectBox.scale = Vector2.ZERO
		_last_mouse_pos = get_global_mouse_position()
	
	if event is InputEventWithModifiers and _edit_mode == EditMode.FREE:
		# Multi-Select with Shift held down while drawing the Box
		if event.is_action_released("Select") and event.shift_pressed:
			_drawing_select_box = false
			$SelectBox.visible = false
			_select_points_inside_select_box(true)
			_select_rect = Rect2()
		# Single-Select while drawing the Box (Deselects other points)
		elif event.is_action_released("Select") and not event.shift_pressed:
			_drawing_select_box = false
			$SelectBox.visible = false
			_select_points_inside_select_box(false)
			_select_rect = Rect2()
	
	# Add/Delete points
	if event.is_action_pressed("AddPoint") and _edit_mode == EditMode.FREE:
		_add_point(get_global_mouse_position().snapped(Global.SNAP_RANGE))
	if event.is_action_pressed("Delete") and _edit_mode == EditMode.FREE:
		_dessolve_selected()
		for p in $EdgeMesh.get_children():
			if p.state == Global.PointState.SELECTED:
				p.queue_free()
	
	# Move mode
	if event.is_action_pressed("ToggleMoveMode"):
		# Only toggle on if it has a selection
		if _edit_mode == EditMode.FREE:
			var has_selection = false
			for p in $EdgeMesh.get_children():
				if p.state == Global.PointState.SELECTED:
					has_selection = true
			if not has_selection:
				return
		
		if _edit_mode == EditMode.MOVE:
			_edit_mode = EditMode.FREE
			for p in $EdgeMesh.get_children():
				p.state = Global.PointState.FREE
		elif _edit_mode == EditMode.FREE:
			_edit_mode = EditMode.MOVE
			_last_mouse_pos = get_global_mouse_position()
			for p in $EdgeMesh.get_children():
				if p.state == Global.PointState.SELECTED:
					p.last_position = p.position
					p.state = Global.PointState.MOVING
		
	# Add/Dissolve edges
	if event.is_action_pressed("AddEdge"):
		var points: Array[String] = []
		for p in $EdgeMesh.get_children():
			if p.state == Global.PointState.SELECTED:
				points.append(p.name)
			if points.size() == 2:
				$EdgeMesh.edges.append(points)
				$EdgeMesh.update_mesh()
				break
	
	if event.is_action_pressed("Dissolve"):
		_dessolve_selected()


	
	
	

func _select_points_inside_select_box(inclusive: bool = false):
	for p in $EdgeMesh.get_children():
		if _select_rect.has_point(p.position):
			p.state = Global.PointState.SELECTED
		else:
			if inclusive:
				continue
			p.state = Global.PointState.FREE
			

func _add_point(p_position: Vector2):
	var i = 0
	while $EdgeMesh.has_node("p%s" % i):
		i += 1
	var inst = Point.instantiate()
	$EdgeMesh.add_child(inst)
	inst.name = "p%s" % i
	inst.position = p_position


func _dessolve_selected():
	var selected_points: Array[String] = []
	for p in $EdgeMesh.get_children():
		if p.state == Global.PointState.SELECTED:
			selected_points.append(p.name)
	
	for p in selected_points:
		for i in range($EdgeMesh.edges.size()-1, -1, -1):
			if p in $EdgeMesh.edges[i]:
				$EdgeMesh.edges.remove_at(i)
		
	$EdgeMesh.update_mesh()



	#if Global.mode == Global.Mode.FREE:
		#if Input.is_action_just_pressed("MovePoints"):
			#Global.mode = Global.Mode.MOVE
			#_last_mouse_pos = get_global_mouse_position()
			#for p in Global.selected_nodes:
				#p.last_pos = p.position
		#if Input.is_action_just_pressed("AddEdge"):
			#Global.edges.append(["p0","p1"])
			#$EdgeMesh.update_mesh()

	#elif Global.mode == Global.Mode.MOVE:
		#if Input.is_action_just_pressed("MovePoints") or Input.is_action_just_pressed("Select"):
			#Global.mode = Global.Mode.FREE
			#_last_mouse_pos = get_global_mouse_position()


#func get_selected_point() -> Node2D:
	#var mouse_pos = get_global_mouse_position()
	#for p in $EdgeMesh.get_children():
		#if p.position.distance_to(mouse_pos) < Global.POINT_CLICK_RADIUS:
			#return p
	#return null

#
#func _process(_delta):
	#if Global.mode == Global.Mode.MOVE:
		#var sub = _last_mouse_pos - get_global_mouse_position()
		#for p in Global.selected_nodes:
			#p.position = (p.last_pos - sub).snapped(Global.SNAP_RANGE)
