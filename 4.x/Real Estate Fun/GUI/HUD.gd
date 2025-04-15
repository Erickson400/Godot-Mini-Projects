extends Control

signal LandBuy
signal SaleHouseBuy
signal HouseSell
signal HouseUpgrade1
signal HouseUpgrade2
signal HouseUpgrade3
signal SuppliesBuy1
signal SuppliesBuy2
signal SuppliesBuy3
signal WorkerBuy1
signal WorkerBuy2
signal WorkerBuy3

func _process(_delta):
	$Money.text = "Money: " + str(Singleton.Money)
	$Supplies.text = "Supplies: " + str(Singleton.Supplies)
	$Workers.text = "Workers: " + str(Singleton.Workers)

func SetRentBar(num:int):
	$TabBar/House/ProgressBar.value = num

func SetAvailabeUpgrades(list:Array):
	if list[0] == false:
		$TabBar/House/Button2.visible = false
	if list[1] == false:
		$TabBar/House/Button3.visible = false
	if list[2] == false:
		$TabBar/House/Button4.visible = false

func SetTab(tab:int):
	if tab > $TabBar.get_child_count():
		return
	for t in $TabBar.get_children():
		t.visible = false
	$TabBar.get_child(tab).visible = true
	if $TabBar.get_child(tab).name == "Info":
		Singleton.UpdateInfo()
		$TabBar.get_child(tab).get_node("Owned").text = "Owned: " + str(Singleton.OwnedPlots)
		$TabBar.get_child(tab).get_node("NetWorth").text = "Net Worth: " + str(Singleton.NetWorth)

func _on_Button_pressed():
	emit_signal("LandBuy")

func _on_Button_pressed1():
	emit_signal("SaleHouseBuy")

func _on_Button_pressed2():
	emit_signal("HouseSell")

func _on_Button2_pressed():
	emit_signal("HouseUpgrade1")

func _on_Button3_pressed():
	emit_signal("HouseUpgrade2")

func _on_Button4_pressed():
	emit_signal("HouseUpgrade3")

func _on_Button2_pressedsup1():
	emit_signal("SuppliesBuy1")

func _on_Button3_pressedsup2():
	emit_signal("SuppliesBuy2")

func _on_Button4_pressedsup3():
	emit_signal("SuppliesBuy3")

func _on_Button2_pressed_w1():
	emit_signal("WorkerBuy1")

func _on_Button3_pressedw2():
	emit_signal("WorkerBuy2")

func _on_Button4_pressedw3():
	emit_signal("WorkerBuy3")

func _on_Info_pressedTab():
	self.SetTab(0)

func _on_Workers_pressedTab():
	self.SetTab(5)

func _on_Suplioes_pressedTab():
	self.SetTab(4)



