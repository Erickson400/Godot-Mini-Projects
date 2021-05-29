extends Control

var coins = 0

func add_label_coins():
	coins += 1
	$CoinsLabel.text = "Coins: %d" % coins


