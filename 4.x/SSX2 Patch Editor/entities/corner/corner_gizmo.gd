class_name CornerGizmo
extends Node3D


signal transformed

enum HandleGroup {
	NONE,
	LEFT_FRONT,
	RIGHT_FRONT,
	LEFT_BACK,
	RIGHT_BACK,
}

var active_handle_group: int = HandleGroup.NONE

var _corner_ref: Node3D = null

@onready var lines: MeshInstance3D = $Lines
@onready var gizmo_handles: Array[Node3D] = [] 
@onready var center = $Center


func _ready() -> void:
	$Center/TransformComponent.nodes_to_transform.append(center)
	for handle in $Handles.get_children():
		gizmo_handles.append(handle as Node3D)
	
	$Center/TransformComponent.connect("transformed", _on_transform_component_transformed)

	for handle in gizmo_handles:
		var comp: TransformComponent = handle.get_node("TransformComponent")
		comp.nodes_to_transform = [comp.get_parent()]
		if not comp.is_connected("transformed", _on_transform_component_transformed):
			comp.connect("transformed", _on_transform_component_transformed)


func _process(delta: float) -> void:
	_update_lines()


func _update_lines():
	var line := SurfaceTool.new()
	line.begin(Mesh.PRIMITIVE_LINES)
	line.set_color(Color.GREEN)
	
	for handle in gizmo_handles:
		if handle.visible:
			line.add_vertex(to_local(center.global_position))
			line.add_vertex(to_local(handle.global_position))
	
	lines.mesh = line.commit()
	lines.mesh.resource_local_to_scene = true


func set_corner(corner: Node3D, active_handles: String):
	_corner_ref = corner
	global_position = corner.global_position
	
	$"Handles/-X".global_position = corner.get_node(NodePath("Handles/-X")).global_position
	$"Handles/+X".global_position = corner.get_node(NodePath("Handles/+X")).global_position
	$"Handles/-Z".global_position = corner.get_node(NodePath("Handles/-Z")).global_position
	$"Handles/+Z".global_position = corner.get_node(NodePath("Handles/+Z")).global_position
	
	match active_handles:
		"left_front":
			active_handle_group = HandleGroup.LEFT_FRONT
			$"Handles/-X".hide()
			$"Handles/-X".get_node("CollisionShape3D").disabled = true
			$"Handles/-Z".hide()
			$"Handles/-Z".get_node("CollisionShape3D").disabled = true
		"right_front":
			active_handle_group = HandleGroup.RIGHT_FRONT
			$"Handles/+X".hide()
			$"Handles/+X".get_node("CollisionShape3D").disabled = true
			$"Handles/-Z".hide()
			$"Handles/-Z".get_node("CollisionShape3D").disabled = true
		"left_back":
			active_handle_group = HandleGroup.LEFT_BACK
			$"Handles/-X".hide()
			$"Handles/-X".get_node("CollisionShape3D").disabled = true
			$"Handles/+Z".hide()
			$"Handles/+Z".get_node("CollisionShape3D").disabled = true
		"right_back":
			active_handle_group = HandleGroup.RIGHT_BACK
			$"Handles/+X".hide()
			$"Handles/+X".get_node("CollisionShape3D").disabled = true
			$"Handles/+Z".hide()
			$"Handles/+Z".get_node("CollisionShape3D").disabled = true


func _on_transform_component_transformed():
	_corner_ref.global_position = $Center.global_position
	_corner_ref.get_node(NodePath("Handles/-X")).global_position = $"Handles/-X".global_position
	_corner_ref.get_node(NodePath("Handles/-X")).global_position = $"Handles/-X".global_position
	_corner_ref.get_node(NodePath("Handles/+X")).global_position = $"Handles/+X".global_position
	_corner_ref.get_node(NodePath("Handles/-Z")).global_position = $"Handles/-Z".global_position
	_corner_ref.get_node(NodePath("Handles/+Z")).global_position = $"Handles/+Z".global_position
	ModeManager.update_selected_patch()
	transformed.emit()


	
