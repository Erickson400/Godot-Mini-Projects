extends Node2D


enum GameState {PLAYING, LOST, WON}
const ITEM_SCN = preload("res://scenes/entities/items/item.tscn")

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
var game_state: int = GameState.PLAYING
var end_game_timer: float = 0
var played_gameover_sound: bool = false 

# Entities
@onready var characters: Dictionary = {
	"player": $Characters/Player,
	"finance": $Characters/Finance,
	"computers": $Characters/Computers,
	"teachers": $Characters/Teachers,
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
	for i in 9:
		item_score_target[item_score_target.keys().pick_random()] += 1
	
	for character in characters.values():
		character.characer_knocked.connect(_on_character_knocked)
	
	hud.hide()
	dialogue_haha.hide()
	dialogue_screw_you.hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().change_scene_to_file("res://scenes/title/title.tscn")
	
	# DEBUG
	#if Input.is_action_just_pressed("QuickQuit"):
		#get_tree().quit()
		
	# DEBUG Faster dialogue
	segment_timer += 1 #5
	if segment_timer <= 600:
		_dialogue_stage()
	else:
		GlobalTheme.stop()
		end_game_timer += delta
		end_game_timer = clamp(end_game_timer, 0, 60)
		_game_stage()
		_update_hud_text()
		hud.show()


func _update_hud_text():
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
	if end_game_timer < 30:
		time_color = Color(0, 1, 0)
	if end_game_timer >= 30:
		time_color = Color(1, 1, 0)
	if end_game_timer >= 50:
		time_color = Color(1, 0, 0)

	hud_time.label_settings.font_color = time_color
	hud_time.text = str(round(60-end_game_timer))


func _dialogue_stage():
	characters["player"].flip_h = false
	characters["finance"].flip_h = true
	characters["computers"].flip_h = true
	characters["teachers"].flip_h = true

	# Dom talk
	if segment_timer < 400:
		if randi() % 4 == 0:
			characters["player"].frame = randi_range(6, 7)
		
		dialogue_cash_target.text = str(item_score_target["cash"])
		dialogue_computers_target.text = str(item_score_target["computers"])
		dialogue_teachers_target.text = str(item_score_target["teachers"])
	
	# Enemy talk
	if segment_timer >= 400:
		characters["player"].frame = 0
		characters["finance"].frame = 3
		characters["computers"].frame = 3
		characters["teachers"].frame = 3

		# Hide everything but show haha and screw_you
		for label in $Dialogue.get_children():
			label.hide()
		dialogue_haha.show()
		dialogue_screw_you.show()


func _game_stage():
	dialogue_haha.hide()
	dialogue_screw_you.hide()
	for chara in characters.values():
		chara.is_on_dialogue_segment = false
	
	_gameover_check()


func _gameover_check():
	# If timer reached 60sec:
	# Win if item targets are reached.
	# Lose if item targets are not reached.
	if end_game_timer >= 60:
		if (
			item_score["cash"] >= item_score_target["cash"] and
			item_score["computers"] >= item_score_target["computers"] and
			item_score["teachers"] >= item_score_target["teachers"]
			):
			game_state = GameState.WON
			characters["player"].frame = 9
			characters["finance"].frame = 5
			characters["computers"].frame = 5
			characters["teachers"].frame = 5
			
			hud_cvg.text = "CVG is SAVED!"
			hud_esc.text = "Press ESC"
			hud_cvg.show()
			hud_esc.show()
			
			if not played_gameover_sound:
				$Win.play()
				played_gameover_sound = true
		else:
			game_state = GameState.LOST
			characters["player"].frame = 8
			characters["finance"].frame = 0
			characters["computers"].frame = 0
			characters["teachers"].frame = 0
			
			hud_cvg.text = "CVG is SCREWED!"
			hud_esc.text = "Press ESC"
			hud_cvg.show()
			hud_esc.show()
			
			if not played_gameover_sound:
				$Lose.play()
				played_gameover_sound = true
	
		for chara in characters.values():
			chara.is_gameover = true
			

func _on_character_knocked(character: Variant) -> void:
	if character.name == "Player":
		# If the player's health is below 1, then knock a random item from it.
		# Only knock an item if the item score is above 0.
		var random_item = ["cash", "computers", "teachers"].pick_random()
		
		if item_score[random_item] > 0:
			var item_inst = ITEM_SCN.instantiate()
			add_child(item_inst)
			item_inst.position.x = character.position.x
			item_inst.position.y = character.position.y + 30
			item_inst.type = random_item
			item_inst.move_right = not character.flip_h
			
			item_score[random_item] -= 1
			character.play_lose()
	
	elif character.name == "Finance":
		var item_inst = ITEM_SCN.instantiate()
		add_child(item_inst)
		item_inst.position.x = character.position.x
		item_inst.position.y = character.position.y + 30
		item_inst.type = "cash"
		item_inst.move_right = not character.flip_h
		
		item_score["cash"] += 1
		character.play_lose()
	
	elif character.name == "Computers":
		var item_inst = ITEM_SCN.instantiate()
		add_child(item_inst)
		item_inst.position.x = character.position.x
		item_inst.position.y = character.position.y + 30
		item_inst.type = "computers"
		item_inst.move_right = not character.flip_h
		
		item_score["computers"] += 1
		character.play_lose()
	
	elif character.name == "Teachers":
		var item_inst = ITEM_SCN.instantiate()
		add_child(item_inst)
		item_inst.position = character.position
		item_inst.type = "teachers"
		item_inst.move_right = not character.flip_h
		
		item_score["teachers"] += 1
		character.play_lose()
	
