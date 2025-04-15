extends AnimatedSprite2D
class_name Character


signal characer_knocked(character)

enum State {NORMAL = 0, HURT = 1, PUNCHING = 10}
enum NormalAction {STAND, MOVE, PUNCH}
enum LevelBoundary {LEFT = 8, RIGHT = 808}
const WALKING_FRAMES = [1, 0, 2]
const SPEED = 2

# Is the character playable? Only Dom is.
@export var is_player: bool = false
# Audio
@export var hit: AudioStream = null
@export var pain: AudioStream = null
@export var lose: AudioStream = null

# If health reaches 0, then it will be set to a random range 6 - 8.
# If the character is the player, then 3 - 6.
var health: int = 5
var state: int = State.NORMAL # NORMAL, HURT, PUNCHING.
# Action the CPU has choosen to do while on the NORMAL state.
var normal_action: int = NormalAction.MOVE # STAND, MOVE, PUNCH
var is_on_dialogue_segment: bool = true
# Prevents it from updating itself after gameover.
var is_gameover: bool = false
# A delay that resets every 8 frames, then it changes walking frame.
var walking_delay: int = 0
# Delay for the duration of states. Seperate form walking_delay to prevent conflicts.
var state_delay: int = 0
# The index of the WALKING_FRAMES array. 1, 0, 2...repeat.
# It should wrap after index 2.
var walking_step_frame: int = 0
# Target X position. Character moves towards it.
var target_x_position: int = randi_range(LevelBoundary.LEFT, LevelBoundary.RIGHT)
var controls: Dictionary = { "left": false, "right": false, "space":  false}

#----------------------------------------

# Is in the punching animation
var occupy = false


func _ready():
	$Hit.stream = hit
	$Pain.stream = pain
	$Lose.stream = lose


func _process(_delta: float) -> void:
	if is_on_dialogue_segment or is_gameover:
		return
	
	_update_controls()
	_update_movement()
	_update_states()
	
	# Knocked. Game scene must create the knocked items and change the score.
	if health < 1:
		if state != State.HURT:
			health = randi_range(3, 6) if is_player else randi_range(6, 8)
			characer_knocked.emit(self)
			state = State.HURT


func _update_controls():
	for button in controls.keys():
		controls[button] = false

	if is_player:
		if Input.is_action_pressed("Left"):
			controls["left"] = true
		if Input.is_action_pressed("Right"):
			controls["right"] = true
		if Input.is_action_pressed("Space"):
			controls["space"] = true
	else:
		# CPU
		# 1/21 chance of changing target and normal_action.
		if randi_range(0, 20) == 1:
			target_x_position = randi_range(LevelBoundary.LEFT, LevelBoundary.RIGHT)
			# 1/3 chance to either stand, move, or punch
			normal_action = randi_range(0, 2)
			
		# Stand
		if normal_action == NormalAction.STAND:
			frame = 0
	
		# Move
		if normal_action == NormalAction.MOVE:
			# Move towards the target. If its 10 pixels close to the target, then
			# dont move and set normal_action to Stand
			if position.x > target_x_position:
				controls["left"] = true
			if position.x < target_x_position:
				controls["right"] = true
			if position.x > target_x_position - 10 and position.x < target_x_position + 10:
				controls["left"] = false
				controls["right"] = false
				normal_action = NormalAction.STAND
			
		# Punch
		if normal_action == NormalAction.PUNCH:
			controls["space"] = true
			normal_action = NormalAction.STAND


func _update_movement():
	# If want to move and state is NORMAL.
	if (controls["left"] or controls["right"]) and state == State.NORMAL:
		# Step cycle
		walking_delay += 1
		if walking_delay > 7:
			walking_delay = 0
			walking_step_frame = (walking_step_frame + 1) % 3
			frame = WALKING_FRAMES[walking_step_frame]
		
		# Movement
		if controls["left"]:
			flip_h = true
			position.x -= SPEED
		if controls["right"]:
			flip_h = false
			position.x += SPEED
			
	# Punch
	if controls["space"]:
		state = State.PUNCHING


func _update_states():
	# Hurt
	if state == State.HURT:
		frame = 5
		z_index = -1
		state_delay += 1
		if state_delay > 20:
			frame = 0
		if state_delay > 28:
			state_delay = 0
			z_index = 0
			state = State.NORMAL
	
	# Punching
	if state == State.PUNCHING:
		frame = 3
		state_delay += 1
		if state_delay > 10 and state_delay < 15:
			position.x += -1 if flip_h else 1		
		if state_delay > 10:
			frame = 4
			z_index = 1

			find_someone_to_punch()
			if state_delay > 25:
				frame = 0
				z_index = -1
			if state_delay > 31:
				state_delay = 0
				state = State.NORMAL
				#occupy = false
	
	# Boundary check
	if position.x < LevelBoundary.LEFT:
		position.x = LevelBoundary.LEFT
	if position.x > LevelBoundary.RIGHT:
		position.x = LevelBoundary.RIGHT
	

func find_someone_to_punch():
	# Find someone to punch and give damage
	for opponent in get_tree().get_nodes_in_group("character"):
		# Skip if punching yourself
		if self == opponent:
			continue
		
		# Facing someone?
		var opponent_found = false
		if position.x < opponent.position.x and not flip_h:
			opponent_found = true
		if position.x > opponent.position.x and flip_h:
			opponent_found = true
		
		# Check if the character is within 41 pixels from the opponent.
		# Contact?
		if (
			position.x < opponent.position.x + 41 and
			position.x > opponent.position.x - 41 and
			opponent_found and occupy == false
			):
			play_hit()
			opponent.play_pain()
			
			# Knockback
			opponent.position.x += -7 if flip_h else 7
			#chara.occupy = true
			opponent.state = State.HURT
			
			# Enemies can hit each other but they can only damage the player.
			# Only give damage if the opponent is the player
			if is_player:
				opponent.health -= 1
			else:
				if opponent.is_player:
					opponent.health -= 1

	# After punching, go back to normal state.
	# Reset the ready and occupy flags too.
	if state_delay > 25:
		frame = 0
		z_index = -1
	if state_delay > 31:
		state_delay = 0
		state = State.NORMAL
		#chara.occupy = false


func play_pain():
	if $Pain.playing:
		return
	$Pain.play()


func play_hit():
	if $Hit.playing:
		return
	$Hit.play()


func play_lose():
	if $Lose.playing:
		return
	$Lose.play()
	
