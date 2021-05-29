extends Spatial

var noise = OpenSimplexNoise.new()
var material = preload("res://Assets/BlockMat.material")
var Class_Chunk = preload("res://Scripts/Class_Chunk.gd")

func _ready():
	randomize()
	noise.seed = randi()
	noise.octaves = 4 #4
	noise.period = 200 #20.0
	noise.persistence = 0.8 #0.8
	
	var thread = Thread.new()
	thread.start(self, "Load_Chunks", null)
	
	
func _process(_delta):
	$Water.translation.x = $Player.translation.x
	$Water.translation.z = $Player.translation.z
	
func Load_Chunks(thread_arg):
	for x in 20:
		for y in 20:
			var chunk_inst = Class_Chunk.new(noise, Vector2(x*16,y*16))
			chunk_inst.translation = Vector3(x*32,2,y*32)
			$Chunks_Parent.add_child(chunk_inst)


















