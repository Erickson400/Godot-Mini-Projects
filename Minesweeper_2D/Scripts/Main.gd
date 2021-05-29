extends Node

# 32 is the size of each tile, since they are scaled up by 4

const Size = Vector2(20,16) # Minus 4 on Y because of the HUD
const minesChance =  15		# 0% - 100% chance

var gameState = "playing"
var timer = 0
var mines = 0


enum NonNumeric_Tiles {
	blank = 9,
	flag,
	mine
}

func _ready():
	randomize()
	generate_board()
	
func _input(event):
	if gameState == "playing":
		if Input.is_action_just_pressed("Left_Click"):
			var clampedPos:Vector2
			clampedPos.x = get_viewport().get_mouse_position().x
			clampedPos.y = get_viewport().get_mouse_position().y-32*4
			
			if clampedPos.x > 0 && clampedPos.y > 0:
				$HUD/FaceBG/Face.frame = 13
				
		if Input.is_action_just_released("Left_Click"):
			var clampedPos:Vector2
			clampedPos.x = get_viewport().get_mouse_position().x
			clampedPos.y = get_viewport().get_mouse_position().y-32*4
			
			if clampedPos.x > 0 && clampedPos.y > 0:
				clampedPos.x = clamp(clampedPos.x, 0, 640)
				clampedPos.y = clamp(clampedPos.y, 0, 512)
				
				var griddedPos = Vector2(clampedPos.x/32, clampedPos.y/32)
				
				$Tiles.set_cellv(griddedPos, -1)
				clickedTile(griddedPos)
				
			if gameState == "playing":
				$HUD/FaceBG/Face.frame = 12
			
		if Input.is_action_just_pressed("Right_Click"):
			var clampedPos:Vector2
			clampedPos.x = get_viewport().get_mouse_position().x
			clampedPos.y = get_viewport().get_mouse_position().y-32*4
			
			if clampedPos.x > 0 && clampedPos.y > 0:
				clampedPos.x = clamp(clampedPos.x, 0, 640)
				clampedPos.y = clamp(clampedPos.y, 0, 512)
				
				var griddedPos = Vector2(clampedPos.x/32, clampedPos.y/32)
				
				if $Tiles.get_cellv(griddedPos) == NonNumeric_Tiles.flag:
					$Tiles.set_cellv(griddedPos, NonNumeric_Tiles.blank)
					mines+=1
					$HUD/MinesLeft.text = "%03d" % mines
				else:
					$Tiles.set_cellv(griddedPos, NonNumeric_Tiles.flag)
					mines-=1
					$HUD/MinesLeft.text = "%03d" % mines
	


# Startup
func generate_board():
	timer=0
	mines=0
	gameState = "playing"
	$HUD/FaceBG/Face.frame = 12
	$HUD/Timer.text = "%03d" % timer
	$Timer.start()
	$MapData.clear()
	
	# Make mines
	for x in Size.x:
		for y in Size.y:
			if randi() % 100 < minesChance:
				mines+=1
				$MapData.set_cell(x, y, 11)
	$HUD/MinesLeft.text = "%03d" % mines

	# Make numbers
	for x in Size.x:
		for y in Size.y:
			if $MapData.get_cell(x,y) != NonNumeric_Tiles.mine:
				$MapData.set_cell(x, y, Check_Sides(Vector2(x,y)))

	# Make tiles
	for x in Size.x:
		for y in Size.y:
			$Tiles.set_cell(x, y, NonNumeric_Tiles.blank)

func Check_Sides(position:Vector2) -> int:
	# Checks if there is a mine on any of the 8 side tiles
	# it then returns the number of mines next to it
	
	var Side_Vectors = {
		"topleft":Vector2(-1,-1),
		"topmiddle":Vector2(0,-1),
		"topright":Vector2(1,-1),
		"middleleft":Vector2(-1,0),
		"middleright":Vector2(1,0),
		"bottomleft":Vector2(-1,1),
		"bottommiddle":Vector2(0,1),
		"bottomright":Vector2(1,1),
	}
	
	var foundMines = 0
	
	for n in Side_Vectors.values():
		if $MapData.get_cellv(position+n) == NonNumeric_Tiles.mine:
			foundMines+=1
			
	return foundMines

# Gameover
func game_over():
	gameState = "dead"
	$HUD/FaceBG/Face.frame = 14
	$Tiles.clear()

# Game mechanics
func clickedTile(position:Vector2):
	var cell_Type = $MapData.get_cellv(position)
	
	if cell_Type == NonNumeric_Tiles.mine:
		game_over()
	if cell_Type == NonNumeric_Tiles.flag:
		print("Flag")
	





func _on_Button_pressed():
	generate_board()

func _on_Timer_timeout():
	if gameState == "playing" && timer<999:
		timer+=1
		$HUD/Timer.text = "%03d" % timer
