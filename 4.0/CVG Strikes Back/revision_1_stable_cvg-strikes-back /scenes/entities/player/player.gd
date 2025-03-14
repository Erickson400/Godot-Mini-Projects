extends AnimatedSprite2D





@export var flipper = 0
var dir = 0
var delay = 0
var step = 0
var speed = 2
var state = 0
var p_ready = true
var local_frame = 0
@export var control = false
var att = 1
var tx = 0
var occupy = false
var health = 5
@export var hit: AudioStream = null
@export var pain: AudioStream = null
@export var lose: AudioStream = null
var p_left = false
var p_right = false
var p_down = false
var p_up = false
var p_butt_a = false

var pfo = 0

const LEVEL_LEFT = 8
const LEVEL_RIGHT = 808


func _ready():
	$Hit.stream = hit
	$Pain.stream = pain
	$Lose.stream = lose
	set_random_x_target()


func set_random_x_target():
	tx = randi_range(LEVEL_LEFT, LEVEL_RIGHT)


func pain_play():
	$Pain.play()

func hit_play():
	$Hit.play()
