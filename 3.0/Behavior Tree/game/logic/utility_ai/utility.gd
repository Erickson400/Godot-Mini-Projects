extends Node
class_name Utility, "res://game/logic/utility_ai/sims.png"


export(Curve)var curve



var scores = {
	"hunger": 0,
	"idle": 0.5
}
var actions = {}
func _ready():
	actions["Idle"] = get_node("Idle")
	actions["FindFood"] = get_node("FindFood")

var active_action:Action = null

var evaluated = false

func evaluate():
	if evaluated:
		return
	
	var highest_score_key = ""
	for score in scores.keys():
		if highest_score_key == "":
			highest_score_key = score
		elif scores[score] > scores[highest_score_key]:
			highest_score_key = score
	
	if highest_score_key == "":
		active_action = null
		printerr("Highest Score key is empty")
	else:
		if highest_score_key == "hunger":
			active_action = actions["Idle"]
		elif highest_score_key == "idle":
			active_action = actions["FindFood"]
		
		active_action.start()
		#evaluated = true
		#print(active_action)
	
	
	



func _process(delta):
	get_parent().get_node("Label").text = "%s" % scores
	if active_action != null:
		active_action.tick(delta)



