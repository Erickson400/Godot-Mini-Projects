extends Node

signal game_paused(pause: bool)

const SUPPLY_DEALS = [
	{ "supplies": 25, "price": 5_000 },
	{ "supplies": 100, "price": 19_000 },
	{ "supplies": 250, "price": 45_000 },
	{ "supplies": 500, "price": 85_000 },
	{ "supplies": 1000, "price": 160_000 }
]
const WORKER_DEALS = [
	{ "workers": 1, "price": 30_000 },
	{ "workers": 2, "price": 50_000 },
	{ "workers": 5, "price": 110_000 }
]
const HOUSE_UPGRADES = [
	{
		"supplies_needed": 10,
		"workers_needed": 1,
		"adds_value": 3_000,
		"adds_rent": 36
	},
	{
		"supplies_needed": 15,
		"workers_needed": 1,
		"adds_value": 5_000,
		"adds_rent": 54
	},
	{
		"supplies_needed": 20,
		"workers_needed": 2,
		"adds_value": 600,
		"adds_rent": 72
	}
]
const TIME_TO = {
	"pay_rent": 20,
	"pass_month": 20,
	"buy_supplies": 4,
	"buy_workers": 4,
	"build_house": 10,
	"destroy_house": 10,
	"upgrade_house": 5,
	"repair_house": 10
}
const PLOT_PRICE = 5_000
const HOUSE_DEFAULT_VALUE = 19_000 # Excludes plot value
const HOUSE_DEFAULT_RENT = 360
const SUPPLIES_TO_BUILD_HOUSE = 100
const WORKERS_TO_BUILD_HOUSE = 1
const WORKERS_TO_DESTROY_HOUSE = 1
const SUPPLIES_TO_REPEAR = 5
const CHANCE_OF_BREAKING_DOWN = 10 # 0 - 1_000. per pay day
const PRICE_TO_BUYBACK_HOUSE = 3_000 # over the original price. Varies by 1_000+-

# Read-Only, set through functions.
var money: int = 30_000
var supplies: int = 100
var busy_workers: int = 0
var idle_workers: int = 1
var max_workers: int = 1
var months: int = 0
var owned_plots: int = 0
var net_worth: int = 0
var total_rent: int = 0
var is_game_paused: bool = false

var _supply_amount: int = 0
var _workers_amount: int = 0


func _ready() -> void:
	($Month as Timer).wait_time = TIME_TO.pass_month
	($SuppliesCountdown as Timer).wait_time = TIME_TO.buy_supplies
	($WorkersCountdown as Timer).wait_time = TIME_TO.buy_workers


func set_pause(pause: bool) -> void:
	is_game_paused = pause
	($Month as Timer).paused = pause
	($SuppliesCountdown as Timer).paused = pause
	($WorkersCountdown as Timer).paused = pause


func pay_rent(rent: int) -> void:
	money += rent


func buy_supplies(deal: int) -> String:
	if SUPPLY_DEALS[deal]["price"] > money:
		return "Not enough money"
	money -= SUPPLY_DEALS[deal]["price"]
	_supply_amount = SUPPLY_DEALS[deal]["supplies"]
	($SuppliesCountdown as Timer).start()
	return "OK"


func buy_workers(deal: int) -> String:
	if WORKER_DEALS[deal]["price"] > money:
		return "Not enough money"
	money -= WORKER_DEALS[deal]["price"]
	_workers_amount = WORKER_DEALS[deal]["workers"]
	($WorkersCountdown as Timer).start()
	return "OK"


func use_workers(amount: int) -> void:
	idle_workers -= amount
	busy_workers += amount


func return_workers(amount: int) -> void:
	idle_workers += amount
	busy_workers -= amount


func buy_plot() -> String:
	if PLOT_PRICE > money:
		return "Not enough money"
	money -= PLOT_PRICE
	net_worth += PLOT_PRICE
	owned_plots += 1
	return "OK"


func sell_plot() -> void:
	money += PLOT_PRICE
	net_worth -= PLOT_PRICE
	owned_plots -= 1


func build_house_start() -> String:
	if SUPPLIES_TO_BUILD_HOUSE > supplies:
		return "Not enough supplies"
	if WORKERS_TO_BUILD_HOUSE > idle_workers:
		return "Not enough workers"
	use_workers(WORKERS_TO_BUILD_HOUSE)
	supplies -= SUPPLIES_TO_BUILD_HOUSE
	return "OK"


func build_house_end() -> void:
	return_workers(WORKERS_TO_BUILD_HOUSE)
	net_worth += HOUSE_DEFAULT_VALUE
	total_rent += HOUSE_DEFAULT_RENT


func destroy_house_start(house_value: int, house_rent: int) -> String:
	if WORKERS_TO_DESTROY_HOUSE > idle_workers:
		return "Not enough workers"
	use_workers(WORKERS_TO_DESTROY_HOUSE)
	net_worth -= house_value
	total_rent -= house_rent
	return "OK"


func destroy_house_end() -> void:
	return_workers(WORKERS_TO_DESTROY_HOUSE)


func sell_house(house_value: int, house_rent: int) -> void:
	net_worth -= house_value + PLOT_PRICE
	owned_plots -= 1
	total_rent -= house_rent
	money += house_value + PLOT_PRICE


func upgrade_house_start(upgrade: int) -> String:
	if HOUSE_UPGRADES[upgrade]["supplies_needed"] > supplies:
		return "Not enough supplies"
	if HOUSE_UPGRADES[upgrade]["workers"] > idle_workers:
		return "Not enough workers"
	use_workers(HOUSE_UPGRADES[upgrade]["workers"])
	supplies -= HOUSE_UPGRADES[upgrade]["supplies_needed"]
	return "OK"


func upgrade_house_end(upgrade: int) -> void:
	return_workers(HOUSE_UPGRADES[upgrade]["workers"])
	net_worth += HOUSE_UPGRADES[upgrade]["adds_value"]
	total_rent += HOUSE_UPGRADES[upgrade]["adds_rent"]
	

func _on_month_timeout() -> void:
	months += 1


func _on_supplies_countdown_timeout() ->  void:
	supplies += _supply_amount


func _on_workers_countdown_timeout() -> void:
	idle_workers += _workers_amount
	max_workers += _workers_amount

