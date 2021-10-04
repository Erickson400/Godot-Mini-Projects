extends Node
##############################################################################
# There are two tilemaps on the scene.
#  The $MapData stores where the numbers and mines are.
# and the $Tiles store the graphical side, $Tile can be
# empty, filled, or flagged.
# To show the number all is needed is to set a tile on $Tile to empty
# and it will just show the number below it (because $MapData is behind it).
##############################################################################

#============================Variables==============================
#Constants
# 32 is the size of each tile, since they are scaled up by 4
const GRID_SIZE = Vector2(20,16) # Minus 4 on Y because of the HUD
const CHANCE_OF_MINE = 10 # 0% - 100% chance

#Enums
enum GAME_STATE {
	PLAYING,
	GAMEOVER
}
enum TILE_TYPE {
	INVINSIBLE = -1,
	BLANK,
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	FILLED,
	FLAG,
	MINE
}
enum SIDE_CHECK {
	BLANK,
	NUMBER,
	MINE
}
enum FACE {
	SMILE = 12,
	WOW,
	CRY,
	GOD
}

#Data
var game_state = GAME_STATE.PLAYING
var active_timer = 0
var active_mines = 0

var queue = []

#================================Overrite Functions================================
func _ready():
	randomize()
	generate_board()
	
func _input(_event):
	if game_state == GAME_STATE.PLAYING:
		$HUD/FaceBG/Face.frame = FACE.SMILE
		
		# Clamp the mouse position
		var clamped_position = Vector2(
			get_viewport().get_mouse_position().x,
			get_viewport().get_mouse_position().y-32*4
		)
		if clamped_position.x > 0 && clamped_position.y > 0:
			clamped_position.x = clamp(clamped_position.x, 0, 640)
			clamped_position.y = clamp(clamped_position.y, 0, 512)
		else:
			$HUD/FaceBG/Face.frame = FACE.SMILE
			return
		var gridded_position = Vector2(clamped_position.x/32, clamped_position.y/32)
		
		# Input
		if Input.is_action_just_pressed("Left_Click"):
			$HUD/FaceBG/Face.frame = FACE.WOW
			
		if Input.is_action_just_released("Left_Click"):
			clicked_tile(gridded_position)
			
		if Input.is_action_just_pressed("Right_Click"):
			# Toggle the flags on a tile
			if $Tiles.get_cellv(gridded_position) == TILE_TYPE.FLAG:
				$Tiles.set_cellv(gridded_position, TILE_TYPE.FILLED)
				active_mines+=1
				$HUD/MinesLeft.text = "%03d" % active_mines
			elif $Tiles.get_cellv(gridded_position) == TILE_TYPE.FILLED:
				$Tiles.set_cellv(gridded_position, TILE_TYPE.FLAG)
				active_mines-=1
				$HUD/MinesLeft.text = "%03d" % active_mines

		if Input.is_action_just_pressed("Middle_Click"):
			middle_mouse(gridded_position)


#================================Functions================================
# Startup
func generate_board():
	# Reset everything
	active_timer = 0
	active_mines = 0
	game_state = GAME_STATE.PLAYING
	$HUD/FaceBG/Face.frame = FACE.SMILE
	$HUD/Timer.text = "%03d" % active_timer
	$Timer.start()
	$MapData.clear()
	
	# Make mines
	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			if randi() % 100 < CHANCE_OF_MINE:
				active_mines+=1
				$MapData.set_cell(x, y, TILE_TYPE.MINE)
	$HUD/MinesLeft.text = "%03d" % active_mines

	# Make numbers
	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			if $MapData.get_cell(x,y) != TILE_TYPE.MINE:
				$MapData.set_cell(x, y, check_sides(Vector2(x,y)).found_mines.size())

	# Make tiles
	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			$Tiles.set_cell(x, y,TILE_TYPE.FILLED)

func check_sides(position:Vector2) -> Dictionary:
	## Returns an dictionary containing arrays of it's sides position,
	## there are four types. Numbers, Blanks, Mines, Flags
	## The data is taken from $MapData, but the flags are from $Tiles
	## !found_numbers! and !found_flags! only works after generating the board
	
	var found_mines = []
	var found_blanks = []
	var found_numbers = []
	var found_flags = []
	
	var side_vectors = [
		Vector2(-1,-1),#topLeft
		Vector2(0,-1),#topMiddle
		Vector2(1,-1),#topRight
		Vector2(-1,0),#middleLeft
		Vector2(1,0),#middleRight
		Vector2(-1,1),#bottomLeft
		Vector2(0,1),#bottomMiddle
		Vector2(1,1),#bottomRight
	]
	
	for n in side_vectors:
		var side_tile_position = position + n
		
		# Check if its out of the grid
		if side_tile_position.x < 0 \
		|| side_tile_position.y < 0 \
		|| side_tile_position.x >= GRID_SIZE.x \
		|| side_tile_position.y >= GRID_SIZE.y:
			continue
		
		match $MapData.get_cellv(side_tile_position):
			TILE_TYPE.MINE:
				found_mines.append(side_tile_position)
			TILE_TYPE.BLANK:
				found_blanks.append(side_tile_position)
			TILE_TYPE.FLAG:
				found_flags.append(side_tile_position)
	
	var return_value = {
		found_mines = found_mines,
		found_blanks = found_blanks,
		found_numbers = found_numbers
	}
	return return_value # Returns How many mines, free sides, and numeric tiles there are

# Game mechanics
func clicked_tile(position:Vector2):
	## Check if its clickable
	var cata_cell_type = $MapData.get_cellv(position)
	var tile_cell_type = $Tiles.get_cellv(position)
	
	if cata_cell_type == TILE_TYPE.MINE:
		game_over()
		return
	if tile_cell_type == TILE_TYPE.FLAG:
		return
	if tile_cell_type == TILE_TYPE.FILLED:
		$Tiles.set_cellv(position, TILE_TYPE.INVINSIBLE)
		if not (cata_cell_type >= TILE_TYPE.ONE \
		&& cata_cell_type <= TILE_TYPE.EIGHT):
			Auto_Uncover(position)

func Auto_Uncover(start_pos:Vector2):
	## Takes a position and reveals all the tiles next to it.
	## Then runs this function on blank tiles
	
	var side_vectors = [
		Vector2(-1,-1),#topLeft
		Vector2(0,-1),#topMiddle
		Vector2(1,-1),#topRight
		Vector2(-1,0),#middleLeft
		Vector2(1,0),#middleRight
		Vector2(-1,1),#bottomLeft
		Vector2(0,1),#bottomMiddle
		Vector2(1,1),#bottomRight
	]
	var other_blanks = []
	
	# Reveal all
	for n in side_vectors:
		if $Tiles.get_cellv(start_pos+n) == TILE_TYPE.INVINSIBLE:
			continue
		
		if $MapData.get_cellv(start_pos+n) == TILE_TYPE.BLANK \
		|| ($MapData.get_cellv(start_pos+n) >= TILE_TYPE.ONE \
		&& $MapData.get_cellv(start_pos+n) <= TILE_TYPE.EIGHT):
			$Tiles.set_cellv(start_pos+n, TILE_TYPE.INVINSIBLE)
		
		if $MapData.get_cellv(start_pos+n) == TILE_TYPE.BLANK:
			other_blanks.append(start_pos+n)
	
	for n in other_blanks:
		Auto_Uncover(n)

func middle_mouse(position:Vector2):
	var side_vectors = [
		Vector2(-1,-1),#topLeft
		Vector2(0,-1),#topMiddle
		Vector2(1,-1),#topRight
		Vector2(-1,0),#middleLeft
		Vector2(1,0),#middleRight
		Vector2(-1,1),#bottomLeft
		Vector2(0,1),#bottomMiddle
		Vector2(1,1),#bottomRight
	]
	
	# Reveal all
	for n in side_vectors:
		if $MapData.get_cellv(position+n) == TILE_TYPE.MINE:
			if not $Tiles.get_cellv(position+n) == TILE_TYPE.FLAG:
				game_over()
		if $Tiles.get_cellv(position+n) == TILE_TYPE.FILLED:
			$Tiles.set_cellv(position+n, TILE_TYPE.INVINSIBLE)

	


func game_over():
	game_state = GAME_STATE.GAMEOVER
	$HUD/FaceBG/Face.frame = FACE.CRY
	$Tiles.clear()




















func _on_Button_pressed():
	generate_board()

func _on_Timer_timeout():
	if game_state == GAME_STATE.PLAYING && active_timer<999:
		active_timer+=1
		$HUD/Timer.text = "%03d" % active_timer
