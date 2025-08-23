class_name PascalCaseModKey
extends Node


#region Your Mod


## Short identifier for your mod. It must be unique among all other mods used by
## a player. It should also match the folder name in the res:// folder where you
## put your main.gd, main.tscn, and all other folders and files.
const MOD_KEY: String = "mod_key"


## Called when the mod is loaded into LORED for the first time
func _ready() -> void:
	get_node("/root/Kit").signals.mods_loaded.connect(_on_mods_loaded)


## Called when all LORED mods finish loading in
func _on_mods_loaded() -> void:
	pass


#endregion





#region Kit helper functions


# NOTE These are examples of how to use the helper functions of the
# Kit class in LORED. They are designed for modders.

# Feel free to delete this region.


#region Examples


## Results in a blank slate of a game, allowing you to fill it with entirely
## custom LOREDs, currencies, Stages, and Upgrades
func kill_all() -> void:
	kill_loreds()
	kill_stages()
	kill_upgrades()
	kill_upgrade_trees()
	kill_currencies()


## Unchanged, this won't work if you call it
func add_custom_stages_and_new_loreds() -> void:
	kill_all()
	
	add_stage(&"new_stage_key", "path_to_stage.json")
	
	add_job(&"custom_job", "res://%s/loreds/jobs/custom_job.json" % key)
	
	add_lored(&"schlonky", "res://%s/loreds/schlonky_data.json" % key)
	add_lored(&"scronky", "res://%s/loreds/scronky_data.json" % key)
	
	refresh_stages()


#endregion


#region Control


func reset_all() -> void:
	reset_upgrades()
	reset_currencies()
	reset_stages()
	reset_loreds()


#region Signals


## When you write `await await_mods_loaded()`, your code will pause until
## `Kit.signals.mods_loaded` is emitted. That will happen after every mod is loaded.
func await_mods_loaded() -> void:
	await get_node("/root/Kit").signals.mods_loaded


#endregion


#region Currency


## Adds `amount` to a specified currency. `amount` can be an int or float,
## or a string in the format of "'mantissa'e'exponent'", e.g. "1e6" or "5.5e20"
func currency_add_amount(currency_key: StringName, amount: Variant) -> void:
	get_node("/root/Kit").currency_add_amount(currency_key, amount)


## Creates a new Currency and stores it in memory. Must be called after its
## Stage has been created (if using a base Stage, you're safe)
func add_currency(currency_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_currency(currency_key, json_path)


## Resets the amount, rate, and pending values of all Currencies
func reset_currencies() -> void:
	get_node("/root/Kit").reset_currencies()


## Remove Currencies from memory by their keys. If `currencies_to_kill` is
## empty, all Currencies will be killed
func kill_currencies(currencies_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_currencies(currencies_to_kill)


#endregion


#region LORED


## Creates a Job using a .json file and stores it in memory for any LORED to use
## Jobs must be added before adding LOREDs which use them.
func add_job(job_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_job(job_key, json_path)


## Creates a new LORED using a .json file and stores them in memory. This will
## NOT create a LOREDPrefab. You must create a Stage scene and place LORED
## placeholder nodes in them. Refer to stage_templace.tscn for help :D
func add_lored(lored_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_lored(lored_key, json_path)


## Removes LOREDs from memory by their keys. If `loreds_to_kill` is empty,
## it will kill every LORED. Murdered LOREDs cannot be resurrected.
func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_loreds(loreds_to_kill)


## Resets all of the current LOREDs in memory to level 1.
func reset_loreds() -> void:
	get_node("/root/Kit").reset_loreds()


#endregion


#region Stage


## Creates a new Stage using a .json file
func add_stage(stage_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_stage(stage_key, json_path)


## Must be called once you're done adding Stages and LOREDs
func refresh_stages() -> void:
	get_node("/root/Kit").refresh_stages()


## Resets the statistics of every Stage in memory
func reset_stages() -> void:
	get_node("/root/Kit").reset_stages()


## Removes Stages from memory by their keys. Does not affect LOREDs who are
## kept in memory. Deletes Stage UI and stats only.
func kill_stages(stages_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_stages(stages_to_kill)


#endregion


#region Upgrade


## Stores a new Upgrade in memory by a key and a path to the json containing the
## Upgrade's data
func add_upgrade(upgrade_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_upgrade(upgrade_key, json_path)


## Sets all Upgrades in memory to unpurchased
## (except `unlock_upgrades` which unlocks the Upgrades window)
func reset_upgrades() -> void:
	get_node("/root/Kit").reset_upgrades()


## Remove Upgrades from memory by their keys. If `upgrades_to_kill` is empty,
## all Upgrades will be killed
func kill_upgrades(upgrades_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_upgrades(upgrades_to_kill)


#endregion


#region Upgrade Tree


## Stores a new Upgrade Tree in memory by a key and a path to the json
## containing the Upgrade Tree's data
func add_upgrade_tree(tree_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_upgrade_tree(tree_key, json_path)


## This will scan all Upgrade Tree scenes for nodes which must be replaced with
## Upgrade Nodes. This should be called once all Tree and Upgrades are added
func refresh_trees() -> void:
	get_node("/root/Kit").refresh_trees()


## Remove Upgrade Trees from memory by their keys. If `trees_to_kill` is empty,
## all Upgrade Trees will be killed
func kill_upgrade_trees(trees_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_upgrade_trees(trees_to_kill)


#endregion


#endregion


#endregion
