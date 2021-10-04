extends Control

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _player_connected(id):
	#var nick = Global.users_id.find(get_tree().get_network_unique_id())
	#nick = Global.users_nick[nick]
	
	SendMessage("Person Joined :"+str(id))
func _player_disconnected(id):
	SendMessage("Person Left :"+str(id))
	Global.Remove_User(id)

func _on_LineEdit_text_entered(new_text):
	self.rpc("SendMessage", $Write.text)
#	if get_tree().is_network_server():
#		SendMessage()
#	else:
#		self.rpc("SendMessage", $Write.text)


remotesync func SendMessage(text = ""):
	var nick = Global.users_id.find(get_tree().get_network_unique_id())
	nick = Global.users_nick[nick]
	
	if text == "":
		$TextChat.text += "\n" + nick + " --  " + $Write.text
		$Write.text = ""
	else:
		$TextChat.text += "\n" + nick + " --  " + text
	

