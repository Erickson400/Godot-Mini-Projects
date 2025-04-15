extends Node

enum State {
	NONE,
	TRANSLATE,
	ROTATE,
	SCALE,
}

enum Type {
	NONE,
	PATCH,
	CORNER,
	HANDLE,
}

var state: State = State.NONE
var type: Type = Type.NONE

@onready var patch_component: Node = $Patch
@onready var corner_component: Node = $Corner
@onready var handle_component: Node = $Handle


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if type == Type.PATCH:
			if state == State.TRANSLATE:
				patch_component.run_translate()
			elif state == State.ROTATE:
				patch_component.run_rotate()
			elif state == State.SCALE:
				patch_component.run_scale()
		elif type == Type.CORNER:
			if state == State.TRANSLATE:
				corner_component.run_translate()
			elif state == State.ROTATE:
				corner_component.run_rotate()
			elif state == State.SCALE:
				corner_component.run_scale()
		elif type == Type.HANDLE:
			if state == State.TRANSLATE:
				handle_component.run_translate()
			elif state == State.ROTATE:
				handle_component.run_rotate()
			elif state == State.SCALE:
				handle_component.run_scale()


func init_patch_translate(p_patch: Patch):
	patch_component.init_translate(p_patch)
	state = State.TRANSLATE
	type = Type.PATCH


func init_patch_rotate(p_patch: Patch):
	patch_component.init_rotate(p_patch)
	state = State.ROTATE
	type = Type.PATCH
	

func init_patch_scale(p_patch: Patch):
	patch_component.init_scale(p_patch)
	state = State.SCALE
	type = Type.PATCH


func init_corner_translate(control_point: Node3D, p_patch: Patch):
	corner_component.init_translate(control_point, p_patch)
	state = State.TRANSLATE
	type = Type.CORNER


func init_corner_rotate(control_point: Node3D, p_patch: Patch):
	corner_component.init_rotate(control_point, p_patch)
	state = State.ROTATE
	type = Type.CORNER


func init_corner_scale(control_point: Node3D, p_patch: Patch):
	corner_component.init_scale(control_point, p_patch)
	state = State.SCALE
	type = Type.CORNER


func init_handle_translate(control_point: Node3D, p_patch: Patch, parent_corner: Corner):
	handle_component.init_translate(control_point, p_patch, parent_corner)
	state = State.TRANSLATE
	type = Type.HANDLE


func init_handle_rotate(control_point: Node3D, p_patch: Patch, parent_corner: Corner):
	handle_component.init_rotate(control_point, p_patch, parent_corner)
	state = State.ROTATE
	type = Type.HANDLE


func init_handle_scale(control_point: Node3D, p_patch: Patch, parent_corner: Corner):
	handle_component.init_scale(control_point, p_patch, parent_corner)
	state = State.SCALE
	type = Type.HANDLE




func patch_commit():
	patch_component.commit()
	state = State.NONE
	type = Type.NONE
	

func patch_revert():
	patch_component.revert()
	state = State.NONE
	type = Type.NONE


func corner_commit():
	corner_component.commit()
	state = State.NONE
	type = Type.NONE


func corner_revert():
	corner_component.revert()
	state = State.NONE
	type = Type.NONE


func handle_commit():
	handle_component.commit()
	state = State.NONE
	type = Type.NONE


func handle_revert():
	handle_component.revert()
	state = State.NONE
	type = Type.NONE
