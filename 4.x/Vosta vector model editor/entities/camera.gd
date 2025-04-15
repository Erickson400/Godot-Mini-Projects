extends Camera2D
## Handle the Camera panning, and the rendering of
## the Grid and Gizmo.

# Grid size is the size of the squares per pixel.
const GRID_SIZE: float = 10
# Lines is the amount of lines that should be created, a big number
# means it's less likely the border will be seen when panning.
const GRID_LINES: int = 250
var _panning = false
var _last_pos = Vector2.ZERO
var _last_mouse_pos = Vector2.ZERO


func _ready():
	# Create grid
	var grid_mesh = ImmediateMesh.new()
	grid_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	grid_mesh.surface_set_color(Color(0.2,0.2,0.2))
	
	for i in range(GRID_LINES):
		# Vertical 10x10
		grid_mesh.surface_add_vertex_2d(Vector2(0, i*GRID_SIZE))
		grid_mesh.surface_add_vertex_2d(Vector2(GRID_LINES*GRID_SIZE, i*GRID_SIZE))
		# Horizontal 10x10
		grid_mesh.surface_add_vertex_2d(Vector2(i*GRID_SIZE, 0))
		grid_mesh.surface_add_vertex_2d(Vector2(i*GRID_SIZE, GRID_LINES*GRID_SIZE))

	for i in range(GRID_LINES):
		# Vertical 100x100
		grid_mesh.surface_add_vertex_2d(Vector2(0, i*100+51))
		grid_mesh.surface_add_vertex_2d(Vector2(GRID_LINES*100, i*100+51))
		# Horizontal 100x100
		grid_mesh.surface_add_vertex_2d(Vector2(i*100+51, 0))
		grid_mesh.surface_add_vertex_2d(Vector2(i*100+51, GRID_LINES*100))

	grid_mesh.surface_end()
	$Grid.mesh = grid_mesh

	# Create Gizmo
	var gizmo_mesh = ImmediateMesh.new()
	gizmo_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	gizmo_mesh.surface_set_color(Color8(0, 130, 0))
	gizmo_mesh.surface_add_vertex_2d(Vector2(0, -3000))
	gizmo_mesh.surface_add_vertex_2d(Vector2(0, 3000))
	gizmo_mesh.surface_set_color(Color8(130, 0, 0))
	gizmo_mesh.surface_add_vertex_2d(Vector2(-3000, 0))
	gizmo_mesh.surface_add_vertex_2d(Vector2(3000, 0))
	gizmo_mesh.surface_end()
	$Gizmo.mesh = gizmo_mesh
	
	_update_grid_n_gizmo()
	


func _unhandled_input(event):
	if event.is_action_pressed("Pan"):
		_panning = true
		_last_pos = position
		_last_mouse_pos = get_global_mouse_position() - position
	if event.is_action_released("Pan"):
		_panning = false

	# Pan the camera based on mouse movement
	if event is InputEventMouseMotion and _panning:
		var sub = _last_mouse_pos - (get_global_mouse_position() - position)
		global_position = _last_pos + sub
		_update_grid_n_gizmo()
		

func _update_grid_n_gizmo():
	# Update Grid Position
	
	$Grid.position.x = -wrap(position.x, 0, 100) - (GRID_SIZE*GRID_LINES)/2
	$Grid.position.y = -wrap(position.y, 0, 100) - (GRID_SIZE*GRID_LINES)/2
	
	# Update Gizmo Position
	$Gizmo.global_transform.origin = Vector2.ZERO
	
	var size = get_viewport().size
	$Gizmo.position.x = clamp($Gizmo.position.x, -size.x/2-20, size.x/2+20)
	$Gizmo.position.y = clamp($Gizmo.position.y, -size.y/2-20, size.y/2+20)
