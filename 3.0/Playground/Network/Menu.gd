extends Control

func _on_Host_button_down():
	# Create server and store the nickname & id
	# Then switch to Room scene
	var net = NetworkedMultiplayerENet.new()
	net.create_server(int($Port/PortEdt.text), 2)
	get_tree().network_peer = net
	Global.stored_nickname = $Nickname/NickEdit.text
	Global.Add_User(get_tree().get_network_unique_id())
	get_tree().change_scene("res://Network/Room.tscn")
	
func _on_Join_button_down():
	# Create client and store the nickname & id
	# Then switch to Room scene
	var net = NetworkedMultiplayerENet.new()
	var error = net.create_client($IP/IPEdit.text, int($Port/PortEdt.text)) # 127.0.0.1 "25.84.229.106"
	if error: 
		print("IP can't be found.")
		return
	get_tree().network_peer = net
	Global.stored_nickname = $Nickname/NickEdit.text
	Global.Add_User(get_tree().get_network_unique_id())
	get_tree().change_scene("res://Network/Room.tscn")




