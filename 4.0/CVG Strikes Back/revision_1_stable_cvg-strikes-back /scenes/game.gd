extends Node2D


## 0-Normal, 1-Hurt, 10-Punch
const NORMAL = 0
const HURT = 1
const PUNCH = 10

## Game state
const PLAYING = 0
const LOST = 1
const WON = 2


var item_score: Dictionary = {
	"cash": 0,
	"computers": 0,
	"teachers": 0,
}
var item_score_target: Dictionary = {
	"cash": 0,
	"computers": 0,
	"teachers": 0,
}
var segment_timer: int = 0

var gameover: int = PLAYING
var timer: float = 0
var ended: bool = false
var a_walk: Array[int] = [1, 0, 2, 0]


# Entities
@onready var players: Array = $Characters.get_children()
@onready var knock_items: Dictionary = {
	"cash": $KnockCash,
	"computers": $KnockComputers,
	"teachers": $KnockTeachers,
}

# Dialogue
@onready var dialogue_we_need_cash: Label = $Dialogue/WeNeedCash
@onready var dialogue_we_need_computers: Label = $Dialogue/WeNeedComputers
@onready var dialogue_we_need_teachers: Label = $Dialogue/WeNeedTeachers
@onready var dialogue_cash_target: Label = $Dialogue/CashTarget
@onready var dialogue_computers_target: Label = $Dialogue/ComputersTarget
@onready var dialogue_teachers_target: Label = $Dialogue/TeachersTarget
@onready var dialogue_haha: Label = $Dialogue/Haha
@onready var dialogue_screw_you: Label = $Dialogue/ScrewYou

# HUD
@onready var hud: Node2D = $HUD
@onready var hud_time: Label = $HUD/Text/Time
@onready var hud_computers_score: Label = $HUD/Text/ComputersScore
@onready var hud_cash_score: Label = $HUD/Text/CashScore
@onready var hud_teachers_score: Label = $HUD/Text/TeachersScore
@onready var hud_computers_target: Label = $HUD/Text/ComputersTarget
@onready var hud_cash_target: Label = $HUD/Text/CashTarget
@onready var hud_teachers_target: Label = $HUD/Text/TeachersTarget
@onready var hud_cvg: Label = $HUD/Text/Gameover/CVG
@onready var hud_esc: Label = $HUD/Text/Gameover/ESC


func _ready():
	randomize()
	for i in 9:
		item_score_target[item_score_target.keys().pick_random()] += 1
	
	hud.hide()
	dialogue_haha.hide()
	dialogue_screw_you.hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().change_scene_to_file("res://scenes/title/title.tscn")
		
	# DEBUG Faster dialogue
	segment_timer += 3
	if segment_timer > 600:
		GlobalTheme.stop()
		timer += delta
		game_stage()
		update_hud_text()
		hud.show()
	else:
		dialogue_stage()


func update_hud_text():
	const YELLOW = Color.YELLOW
	const GREEN = Color.GREEN
	
	# Label color
	if item_score["cash"] < item_score_target["cash"]:
		hud_cash_score.label_settings.font_color = YELLOW
	else:
		hud_cash_score.label_settings.font_color = GREEN
	
	if item_score["computers"] < item_score_target["computers"]:
		hud_computers_score.label_settings.font_color = YELLOW
	else:
		hud_computers_score.label_settings.font_color = GREEN
	
	if item_score["teachers"] < item_score_target["teachers"]:
		hud_teachers_score.label_settings.font_color = YELLOW
	else:
		hud_teachers_score.label_settings.font_color = GREEN
	
	# Label text 
	hud_cash_score.text = str(item_score["cash"])
	hud_computers_score.text = str(item_score["computers"])
	hud_teachers_score.text = str(item_score["teachers"])
	hud_cash_target.text = str(item_score_target["cash"])
	hud_computers_target.text = str(item_score_target["computers"])
	hud_teachers_target.text = str(item_score_target["teachers"])

	# Time color and text
	var time_color = Color()
	if timer < 30:
		time_color = Color(0, 1, 0)
	if timer >= 30:
		time_color = Color(1, 1, 0)
	if timer >= 50:
		time_color = Color(1, 0, 0)

	hud_time.label_settings.font_color = time_color
	hud_time.text = str(round(60-timer))


func dialogue_stage():
	players[0].dir = 0
	players[1].dir = players[1].flipper
	players[2].dir = players[1].flipper
	players[3].dir = players[1].flipper

	# Dom talk
	if segment_timer < 400:
		if randi() % 4 == 0:
			players[0].local_frame = randi_range(6, 7)
		
		dialogue_cash_target.text = str(item_score_target["cash"])
		dialogue_computers_target.text = str(item_score_target["computers"])
		dialogue_teachers_target.text = str(item_score_target["teachers"])
	
	# Enemy talk
	if segment_timer >= 400:
		players[0].local_frame = 0
		players[1].local_frame = 3
		players[2].local_frame = 3
		players[3].local_frame = 3
		
		# Hide everything but show haha and screw_you
		for label in $Dialogue.get_children():
			label.hide()
		dialogue_haha.show()
		dialogue_screw_you.show()
	
	players[0].frame = players[0].local_frame + players[0].dir
	players[1].frame = players[1].local_frame + players[1].dir
	players[2].frame = players[2].local_frame + players[2].dir
	players[3].frame = players[3].local_frame + players[3].dir


func game_stage():
	if timer > 60:
		timer = 60
		gameover = LOST
	
	dialogue_haha.hide()
	dialogue_screw_you.hide()
	
	# Gameover check section
	if (
		timer == 60 and 
		item_score["cash"] >= item_score_target["cash"] and
		item_score["computers"] >= item_score_target["computers"] and
		item_score["teachers"] >= item_score_target["teachers"]
		):
		# Victory
		gameover = WON 
	
	if gameover == WON or gameover == LOST: # If lost or won.
		for p in players:
			p.p_ready = false
		
		if gameover == LOST: # Lose
			players[0].local_frame = 8
			players[1].local_frame = 0
			players[2].local_frame = 0
			players[3].local_frame = 0
			
			hud_cvg.text = "CVG is SCREWED!"
			hud_esc.text = "Press ESC"
			hud_cvg.show()
			hud_esc.show()
			
			if not ended:
				$Lose.play()
				ended = true

		if gameover == WON: # Win
			players[0].local_frame = 9
			players[1].local_frame = 5
			players[2].local_frame = 5
			players[3].local_frame = 5
			
			hud_cvg.text = "CVG is SAVED!"
			hud_esc.text = "Press ESC"
			hud_cvg.show()
			hud_esc.show()
			
			if not ended:
				$Win.play()
				ended = true

	# While the game is playing (0 - Playing)
	if gameover == PLAYING:
		# Controls and state section
		for character in players:
			character.p_left = false
			character.p_right = false
			character.p_down = false
			character.p_up = false
			character.p_butt_a = false
			if character.control:
				if Input.is_action_pressed("Left"):
					character.p_left = true
				if Input.is_action_pressed("Right"):
					character.p_right = true
				if Input.is_action_pressed("Down"):
					character.p_down = true
				if Input.is_action_pressed("Space"):
					character.p_butt_a = true
			
			if not character.control:
				# CPU
				# att 0 - Stand
				# att 1 - Move
				# att 2 - Punch
				
				# 1/21 chance of changing target and att state.
				if randi_range(0, 20) == 1:
					character.set_random_x_target()
					# 1/3 chance to stand, move, or punch
					character.att = randi_range(0, 2)
					
				# Stand
				if character.att == 0:
					character.local_frame = 0
			
				# Move
				if character.att == 1:
					#var frame: Texture2D = character.sprite_frames.get_frame_texture(character.animation, character.frame)
					#var size = frame.get_width()
					
					var new_x = character.position.x# + (size / 2.0)
					
					# Move towards the target. If its 10 pixels close to the target, then
					# dont move and set att to Stand
					if new_x > character.tx:
						character.p_left = true
					if new_x < character.tx:
						character.p_right = true			
					if new_x > character.tx - 10 and new_x < character.tx + 10:
						character.p_left = false 
						character.p_right = false 
						character.att = 0 
					
				# Punch
				if character.att == 2:
					character.p_butt_a = true
					character.att = 0
			
		# Translate input
		for chara in players:
			# Ready loop
			# Ready means it is not in a punch or hurt animation, and is ready to move.
			if chara.p_ready == true:
				# Run this only if moving.
				if chara.p_left or chara.p_right or chara.p_down or chara.p_up:
					# Delay is a timer that goes off every 8 frames, then it changes walking frame.
					chara.delay += 1
					if chara.delay > 7:
						chara.step += 1
						if chara.step > 3:
							chara.step = 0
						# Step is the index of the walking frame array. 1, 0, 2...repeat.
						# Step only reaches 0 - 2, so it cant get the 4th element on the a_walk array
						chara.local_frame = a_walk[chara.step]
						chara.delay = 0
				
				# Movement
				if chara.p_left:
					chara.dir = chara.flipper
					chara.position.x -= chara.speed
				if chara.p_right:
					chara.dir = 0
					chara.position.x += chara.speed
				
				# Punch
				if chara.p_butt_a:
					chara.state = PUNCH
			
			# States
			# Delay might be 0 - 7 when these state checks run. The animation will end faster because
			# its using the same delay variable as the moving step animation. 
			# 1 - Hurt
			if chara.state == HURT:
				chara.p_ready = false
				chara.delay += 1
				chara.local_frame = 5
				chara.z_index = -1
				if chara.delay > 20:
					chara.local_frame = 0
				if chara.delay > 28:
					chara.z_index = 0
					chara.p_ready = true
					chara.delay = 0
					chara.state = NORMAL
			
			# 10 - Punching
			if chara.state == PUNCH:
				chara.p_ready = false
				chara.delay += 1
				chara.local_frame = 3
				if chara.delay > 10:
					if chara.delay < 15:
						if chara.dir == 0:
							chara.position.x += 1
						else:
							chara.position.x -= 1
				
					chara.local_frame = 4
					chara.z_index = 1
					
					# Find someone to punch and give damage
					for v in players.size():
						# Skip if punching yourself
						# Already checked on the contact if statement below, but will leave it here
						# for further work.
						if chara == players[v]:
							continue
						
						# Check if this v character is in front, if so then set the pfo variable to it. 
						# Facing someone?
						chara.pfo = 0
						if chara.position.x < players[v].position.x and chara.dir == 0:
							chara.pfo = v
						if chara.position.x > players[v].position.x and chara.dir == chara.flipper:
							chara.pfo = v
						
						# Check if the character is within 41 pixels from the opponent.
						# Contact?
						if (
							chara.position.x < players[v].position.x + 41 and
							chara.position.x > players[v].position.x - 41 and
							chara.pfo == v and chara != players[v] and chara.occupy == false
							):
							chara.hit_play()
							players[v].pain_play()
							
							# Knockback
							if chara.dir == 0:
								players[v].position.x += 10
							if chara.dir == chara.flipper:
								players[v].position.x -= 10
							chara.occupy = true
							players[v].state = HURT
							
							if not chara.control and v == 0:
								players[v].health -= 1
							if chara.control:
								players[v].health -= 1
					
					# After punching, go back to normal state.
					# Reset the ready and occupy flags too.
					if chara.delay > 25:
						chara.local_frame = 0
						chara.z_index = -1
					if chara.delay > 31:
						chara.p_ready = true
						chara.delay = 0
						chara.state = NORMAL
						chara.occupy = false
				
			# Boundary check
			if chara.position.x < chara.LEVEL_LEFT:
				chara.position.x = chara.LEVEL_LEFT
			if chara.position.x > chara.LEVEL_RIGHT:
				chara.position.x = chara.LEVEL_RIGHT
			
		# Display. set the final animation frame
		for chara in players:
			chara.frame = chara.local_frame + chara.dir
				
		# Item knockers
		if players[0].health < 1:
			# If the player's health is below 1, then knock a random item from it.
			# Only knock an item if the item score is above 0, if not then set the state of the
			# knocker to 0.
			players[0].health = randi_range(3, 6)
			var random_item_key = knock_items.keys().pick_random()
			
			if item_score[random_item_key] > 0:
				knock_items[random_item_key].state = 1
				item_score[random_item_key] -= 1
			else:
				knock_items[random_item_key].state = 0
			
			knock_items[random_item_key].position.x = players[0].position.x
			knock_items[random_item_key].position.x = players[0].position.y - 30
			
			if players[0].dir == 0:
				knock_items[random_item_key].dir = -2
			else:
				knock_items[random_item_key].dir = 2
			
			players[0].get_node("Lose").play()
		
		if players[1].health < 1:
			players[1].health = randi_range(6, 8)
			item_score["cash"] += 1
			knock_items["cash"].state = 1
			knock_items["cash"].position.x = players[1].position.x
			knock_items["cash"].position.y = players[1].position.y + 30
			
			if players[1].dir == 0:
				knock_items["cash"].dir = -2
			else:
				knock_items["cash"].dir = 2
			
			players[1].get_node("Lose").play()
			
		if players[2].health < 1:
			players[2].health = randi_range(6, 8)
			item_score["computers"] += 1
			knock_items["computers"].state = 1
			knock_items["computers"].position.x = players[2].position.x
			knock_items["computers"].position.y = players[2].position.y + 30
			
			if players[2].dir == 0:
				knock_items["computers"].dir = -2
			else:
				knock_items["computers"].dir = 2
			
			players[2].get_node("Lose").play()
			
		if players[3].health < 1:
			players[3].health = randi_range(6, 8)
			item_score["teachers"] += 1
			knock_items["teachers"].state = 1
			knock_items["teachers"].position = players[3].position
			
			if players[3].dir == 0:
				knock_items["teachers"].dir = -2
			else:
				knock_items["teachers"].dir = 2
			
			players[3].get_node("Lose").play()
			
		# Knock item state processing
		for item in knock_items.values():
			# State 0 - inactive
			# State 1 - going up and towards the facing direction
			# State 2 - going up and towards the facing direction
			
			if item.state == 1:
				item.position.x += item.dir
				item.position.y -= 5
				if item.position.y < 280:
					item.state = 2
					
			if item.state == 2:
				item.position.x += item.dir
				item.position.y += 4
				if item.position.y > 450:
					item.state = 0
			
			if item.state > 0:
				item.show()
			else:
				item.hide()
			
		# Colors & Debug
		if Input.is_action_just_pressed("Ctrl"):
			$Oval.show()
		if Input.is_action_just_released("Ctrl"):
			$Oval.hide()
		if Input.is_action_pressed("Ctrl"):
			var color = Color()
			color.r8 = randi_range(100, 255)
			color.b8 = randi_range(0, 255)
			color.g8 = 0
			$Oval.color = color
			$Oval.position = players[0].position
			
		if Input.is_action_just_pressed("1"):
			for chara in players:
				chara.set_random_x_target()
				chara.att = randi_range(0, 2)
			

		
