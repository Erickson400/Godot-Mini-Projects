extends Node


enum Mode {
	PATCH_SELECT,
	PATCH_EDIT,
	CORNER_SELECT,
	CORNER_EDIT,
}

var mode: Mode = Mode.PATCH_SELECT
var _selected_patch: Patch = null
var _selected_bubble: Sprite2D = null
var _is_handle := false

@onready var color_viewport: SubViewport = $ColorViewport


func _ready() -> void:
	color_viewport.main_vewport = get_viewport()


func _unhandled_input(event: InputEvent) -> void:
	if mode == Mode.PATCH_SELECT:
		if event.is_action_pressed("Select"):
			var clicked_patch: Patch = color_viewport.get_patch_on_mouse_position()
			if clicked_patch:
				clicked_patch.enable_select_hue()
			
			if _selected_patch and _selected_patch != clicked_patch:
				_selected_patch.disable_select_hue()
			_selected_patch = clicked_patch
				
		elif event.is_action_pressed("Deselect"):
			if _selected_patch:
				_selected_patch.disable_select_hue()
				_selected_patch = null
		
		elif event.is_action_pressed("Move") and _selected_patch:
			Transformer.init_patch_translate(_selected_patch)
			mode = Mode.PATCH_EDIT
	
		elif event.is_action_pressed("Rotate") and _selected_patch:
			Transformer.init_patch_rotate(_selected_patch)
			mode = Mode.PATCH_EDIT
		
		elif event.is_action_pressed("Scale") and _selected_patch:
			Transformer.init_patch_scale(_selected_patch)
			mode = Mode.PATCH_EDIT
		
		elif event.is_action_pressed("ToggleCornerMode") and _selected_patch:
			if _selected_patch:
				_create_corner_bubbles()
				mode = Mode.CORNER_SELECT

	elif mode == Mode.PATCH_EDIT:
		if event.is_action_pressed("Deselect"):
			Transformer.patch_revert()
			mode = Mode.PATCH_SELECT
			
		if event.is_action_pressed("Select"):
			Transformer.patch_commit()
			mode = Mode.PATCH_SELECT

	elif mode == Mode.CORNER_SELECT:
		if event.is_action_pressed("ToggleCornerMode"):
			BubbleManager.clear_bubbles()
			mode = Mode.PATCH_SELECT
			
		if event.is_action_pressed("Select"):
			BubbleManager.deselect_all()
			_selected_bubble = BubbleManager.get_bubble_sprite_on_mouse()
			if _selected_bubble:
				BubbleManager.select_by_bubble_sprite(_selected_bubble)
			
		elif event.is_action_pressed("Move") and _selected_bubble:
			var control_point = BubbleManager.get_cp_from_bubble(_selected_bubble)
			if control_point is Corner:
				_is_handle = false
				Transformer.init_corner_translate(control_point, _selected_patch)
			else:
				_is_handle = true
				var parent_corner = control_point.get_parent()
				Transformer.init_handle_translate(control_point, _selected_patch, parent_corner)
				
			mode = Mode.CORNER_EDIT
				
		elif event.is_action_pressed("Rotate") and _selected_bubble:
			var control_point = BubbleManager.get_cp_from_bubble(_selected_bubble)
			if control_point is Corner:
				_is_handle = false
				Transformer.init_corner_rotate(control_point, _selected_patch)
			else:
				_is_handle = true
				var parent_corner = control_point.get_parent()
				Transformer.init_handle_rotate(control_point, _selected_patch, parent_corner)
			mode = Mode.CORNER_EDIT
				
		elif event.is_action_pressed("Scale") and _selected_bubble:
			var control_point = BubbleManager.get_cp_from_bubble(_selected_bubble)
			if control_point is Corner:
				_is_handle = false
				Transformer.init_corner_scale(control_point, _selected_patch)
			else:
				_is_handle = true
				var parent_corner = control_point.get_parent()
				Transformer.init_handle_scale(control_point, _selected_patch, parent_corner)
			mode = Mode.CORNER_EDIT
				
	elif mode == Mode.CORNER_EDIT:
		if event.is_action_pressed("Deselect"):
			if _is_handle == true:
				Transformer.handle_revert()
			else:
				Transformer.corner_revert()
			mode = Mode.CORNER_SELECT
			
		if event.is_action_pressed("Select"):
			if _is_handle == true:
				Transformer.handle_commit()
			else:
				Transformer.corner_commit()
			mode = Mode.CORNER_SELECT




func _create_corner_bubbles():
	var add_corner_and_handles: Callable = func(corner: Corner):
		BubbleManager.add_bubble(corner)
		for handle in corner.handle.values():
			BubbleManager.add_bubble(handle, corner)
	add_corner_and_handles.call(_selected_patch.left_front)
	add_corner_and_handles.call(_selected_patch.right_front)
	add_corner_and_handles.call(_selected_patch.left_back)
	add_corner_and_handles.call(_selected_patch.right_back)


func add_mesh_to_select_buffer(patch: Patch, mesh: Mesh):
	color_viewport.add_mesh_to_select_buffer(patch, mesh)
