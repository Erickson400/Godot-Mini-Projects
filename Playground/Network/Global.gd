extends Node

var users_id = []
var users_nick = []

var stored_nickname = ""

func Add_User(id:int):
	users_id.append(id)
	if stored_nickname.empty():
		users_nick.append(str(id))	
	else:
		users_nick.append(stored_nickname)
#func Remove_User(id):
#	var index = users_id.find(id)
#	users_id.remove(index)
#	users_nick.remove(index)
	
