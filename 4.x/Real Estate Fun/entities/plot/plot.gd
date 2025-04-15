extends Node3D

# Game and Plot don't communicate, The HUD is a mediator, talk to it through signals.
# The HUB calls functions from here.
# Only use GameBus constants, dont call functions from it.
signal rent_due(rent)
signal house_built
signal house_broke
signal house_repaired
signal house_destroyed
signal house_upgraded

enum STATE {
	IDLE,
	BUILDING,
	BROKEN,
	REPAIRING,
	UPGRADING,
	DESTROYING,
}

var value: int = GameBus.PLOT_PRICE
var rent: int = 0
var active_upgrades: Array[bool] = [false, false, false]
var owned: bool = false
var state: STATE = STATE.IDLE
var is_paused: bool = false

var _upgrade_index: int = 0


@onready var state_timer = $StateTimer as Timer
@onready var rent_timer = $RentTimer as Timer


func _ready() -> void:
	rent_timer.wait_time = GameBus.HOUSE_DEFAULT_RENT
	for c in $Meshes.get_children():
		c.visible = false


func set_pause(pause: bool) -> void:
	is_paused = pause
	rent_timer.paused = pause
	state_timer.paused = pause


func buy() -> void:
	owned = true


func sell() -> String:
	if state != STATE.IDLE:
		return "Not on idle state"
	owned = false
	return "OK"


func build_house() -> String:
	if state != STATE.IDLE:
		return "Not on idle state"
	state = STATE.BUILDING
	state_timer.wait_time = GameBus.TIME_TO.build_house
	state_timer.start()
	return "OK"


func destroy() -> String:
	if state != STATE.IDLE:
		return "Not on idle state"
	state = STATE.DESTROYING
	state_timer.wait_time = GameBus.TIME_TO.destroy_house
	state_timer.start()
	return "OK"


func repair() -> String:
	if state != STATE.BROKEN:
		return "House is not broken"
	state = STATE.REPAIRING
	state_timer.wait_time = GameBus.TIME_TO.repair_house
	state_timer.start()
	return "OK"


func upgrade(index: int) -> String:
	if state != STATE.IDLE:
		return "Not on idle state"
	state = STATE.UPGRADING
	_upgrade_index = index
	state_timer.wait_time = GameBus.TIME_TO.upgrade_house
	state_timer.start()
	return "OK"


func _on_state_timeout():
	match state:
		STATE.BUILDING:
			value += GameBus.HOUSE_DEFAULT_VALUE
			$Meshes/House.visible = true
			rent_timer.start()
			house_built.emit()
		STATE.REPAIRING:
			rent_timer.start()
			house_repaired.emit()
		STATE.UPGRADING:
			match _upgrade_index:
				0:
					$Meshes/Fence.visible = true
				1:
					$Meshes/Trees.visible = true
				2:
					$Meshes/Decking.visible = true
			value += GameBus.HOUSE_UPGRADES[_upgrade_index]["adds_value"]
			rent += GameBus.HOUSE_UPGRADES[_upgrade_index]["adds_rent"]
			house_upgraded.emit()
		STATE.DESTROYING:
			$Meshes/House.visible = false
			$Meshes/Fence.visible = false
			$Meshes/Trees.visible = false
			$Meshes/Decking.visible = false
			value -= GameBus.HOUSE_DEFAULT_VALUE
			rent_timer.stop()
			house_destroyed.emit()
			
	state = STATE.IDLE


func _on_rent_timeout():
	if (owned
		and state != STATE.BROKEN
		and state != STATE.DESTROYING
		and state != STATE.REPAIRING
	):
		var breaking_chance = randi() % 1_000
		if breaking_chance < GameBus.CHANCE_OF_BREAKING_DOWN:
			state = STATE.BROKEN
			rent_timer.stop()
			house_broke.emit()
		else:
			rent_due.emit(rent)
			
