class_name PascalCaseModKey
extends Node


#region Your Mod


## Short identifier for your mod. It must be unique among all other mods used by
## a player. It should also match the folder name in the res:// folder where you
## put your mod's files!
const MOD_KEY: String = "mod_key"

## There is a Kit class in LORED which has many useful methods for modders. You
## cannot access it directly; so you must call it via get_node("/root/Kit").
## This var is assigned in _ready.
static var kit: Node

## A global reference to your mod. Its type must match the class_name (line 1)
static var instance: PascalCaseModKey


#region Ready


## Called when the mod is loaded into LORED for the first time
func _ready() -> void:
	if not instance:
		instance = self
	_prepare_kit()


func _prepare_kit() -> void:
	if not kit:
		kit = get_node("/root/Kit")
		kit.signals.mods_loaded.connect(_on_mods_loaded)
		kit.signals.saving_begun.connect(_on_saving_begun)
		kit.signals.loading_finished.connect(_on_loading_finished)


## Called when all mods finish loading
func _on_mods_loaded() -> void:
	pass


#endregion


#region Signals


## Called before the game is about to save
func _on_saving_begun() -> void:
	pass


## Called after loading a save file
func _on_loading_finished() -> void:
	pass


#endregion


#endregion



#region LORED Modding Kit Methods


### NOTE These methods are designed for modders. 
### Feel free to delete this region.


## Results in a blank slate of a game, allowing you to fill it with entirely
## custom LOREDs, currencies, Stages, and Upgrades
static func kill_all() -> void:
	kill_loreds()
	kill_stages()
	kill_upgrades()
	kill_upgrade_trees()
	kill_currencies()


static func refresh_all() -> void:
	refresh_stages()
	refresh_trees()


static func reset_all() -> void:
	reset_upgrades()
	reset_currencies()
	reset_stages()
	reset_loreds()


static func format_number(number: float) -> String:
	return kit.format_number(number)


#region Currency


## Adds `amount` to a specified currency. `amount` can be an int or float,
## or a string in the format of "'mantissa'e'exponent'", e.g. "1e6" or "5.5e20"
static func currency_add_amount(currency_key: StringName, amount: Variant) -> void:
	kit.currency_add_amount(currency_key, amount)


## Creates a new Currency and stores it in memory. Must be called after its
## Stage has been created (if using a base Stage, you're safe)
static func add_currency(currency_key: StringName, json_path: String) -> void:
	kit.add_currency(currency_key, json_path)


static func currency_to_int(currency_key: StringName) -> int:
	return kit.currency_to_int(currency_key)


static func currency_get_text(currency_key: StringName) -> String:
	return kit.currency_get_text(currency_key)


#region Comparisons


static func currency_is_equal_to(currency_key: StringName, n: Variant) -> bool:
	return kit.currency_is_equal_to(currency_key, n)


static func currency_is_greater_than(currency_key: StringName, n: Variant) -> bool:
	return kit.currency_is_greater_than(currency_key, n)


static func currency_is_greater_than_or_equal_to(currency_key: StringName, n: Variant) -> bool:
	return kit.currency_is_greater_than_or_equal_to(currency_key, n)


static func currency_is_less_than(currency_key: StringName, n: Variant) -> bool:
	return kit.currency_is_less_than(currency_key, n)


static func currency_is_less_than_or_equal_to(currency_key: StringName, n: Variant) -> bool:
	return kit.currency_is_less_than_or_equal_to(currency_key, n)


#endregion


## Returns a signal which is emitted whenever a Currency amount increases or
## decreases
static func currency_get_changed_signal(currency_key: StringName) -> Signal:
	return kit.currency_get_changed_signal(currency_key)


## Resets the amount, rate, and pending values of all Currencies
static func reset_currencies() -> void:
	kit.reset_currencies()


## Remove Currencies from memory by their keys. If `currencies_to_kill` is
## empty, all Currencies will be killed
static func kill_currencies(currencies_to_kill: Array[StringName] = []) -> void:
	kit.kill_currencies(currencies_to_kill)


#endregion


#region LORED


## Creates a Job using a .json file and stores it in memory for any LORED to use
## Jobs must be added before adding LOREDs which use them.
static func add_job(job_key: StringName, json_path: String) -> void:
	kit.add_job(job_key, json_path)


## Creates a new LORED using a .json file and stores them in memory. This will
## NOT create a LOREDPrefab. You must create a Stage scene and place LORED
## placeholder nodes in them. Refer to stage_templace.tscn for help :D
static func add_lored(lored_key: StringName, json_path: String) -> void:
	kit.add_lored(lored_key, json_path)


## Removes LOREDs from memory by their keys. If `loreds_to_kill` is empty,
## it will kill every LORED. Murdered LOREDs cannot be resurrected.
static func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	kit.kill_loreds(loreds_to_kill)


## Resets all of the current LOREDs in memory to level 1.
static func reset_loreds() -> void:
	kit.reset_loreds()


#endregion


#region Save


static func edit_save_data(mod_key: StringName, data: Variant) -> void:
	kit.edit_save_data(mod_key, data)


#endregion


#region Stage


## Creates a new Stage using a .json file
static func add_stage(stage_key: StringName, json_path: String) -> void:
	kit.add_stage(stage_key, json_path)


## Must be called once you're done adding Stages and LOREDs
static func refresh_stages() -> void:
	kit.refresh_stages()


## Resets the statistics of every Stage in memory
static func reset_stages() -> void:
	kit.reset_stages()


## Removes Stages from memory by their keys. Does not affect LOREDs who are
## kept in memory. Deletes Stage UI and stats only.
static func kill_stages(stages_to_kill: Array[StringName] = []) -> void:
	kit.kill_stages(stages_to_kill)


#endregion


#region Upgrade


## Stores a new Upgrade in memory by a key and a path to the json containing the
## Upgrade's data
static func add_upgrade(upgrade_key: StringName, json_path: String) -> void:
	kit.add_upgrade(upgrade_key, json_path)


## Returns a signal that is emitted whenever an Upgrade is purchased or reset
func upgrade_get_times_purchased_signal(currency_key: StringName) -> Signal:
	return kit.upgrade_get_times_purchased_signal(currency_key)


## Sets all Upgrades in memory to unpurchased
## (except `unlock_upgrades` which unlocks the Upgrades window)
static func reset_upgrades() -> void:
	kit.reset_upgrades()


## Remove Upgrades from memory by their keys. If `upgrades_to_kill` is empty,
## all Upgrades will be killed
static func kill_upgrades(upgrades_to_kill: Array[StringName] = []) -> void:
	kit.kill_upgrades(upgrades_to_kill)


#endregion


#region Upgrade Tree


## Stores a new Upgrade Tree in memory by a key and a path to the json
## containing the Upgrade Tree's data
static func add_upgrade_tree(tree_key: StringName, json_path: String) -> void:
	kit.add_upgrade_tree(tree_key, json_path)


## This will scan all Upgrade Tree scenes for nodes which must be replaced with
## Upgrade Nodes. This should be called once all Tree and Upgrades are added
static func refresh_trees() -> void:
	kit.refresh_trees()


## Remove Upgrade Trees from memory by their keys. If `trees_to_kill` is empty,
## all Upgrade Trees will be killed
static func kill_upgrade_trees(trees_to_kill: Array[StringName] = []) -> void:
	kit.kill_upgrade_trees(trees_to_kill)


#endregion


#endregion
