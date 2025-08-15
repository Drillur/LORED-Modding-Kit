extends Node


#region Your Mod


## Called when the mod is loaded into LORED for the first time
func _ready() -> void:
	get_node("/root/Kit").signals.mods_loaded.connect(_on_mods_loaded)


## Called when all mods finish loading in. This is where you should write your code!
func _on_mods_loaded() -> void:
	pass


#endregion





#region Kit helper functions


# NOTE These are examples of how to use the helper functions of the
# Kit class in LORED. They are designed for modders.

# Feel free to delete this region.


#region Examples


func kill_all() -> void:
	kill_loreds()
	kill_stages()


## Unchanged, this won't work if you call it
func add_custom_stages_and_new_loreds() -> void:
	kill_all()
	
	add_stage(&"new_stage_key", "path_to_stage.json")
	
	add_job(&"custom_job", "res://mod_name/loreds/jobs/custom_job.json")
	
	add_lored(&"schlonky", "res://mod_name/loreds/schlonky_data.json")
	add_lored(&"scronky", "res://mod_name/loreds/scronky_data.json")
	
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


## Does not *kill* currencies; only resets them all to their `starting_amount`
func reset_currencies() -> void:
	get_node("/root/Kit").reset_currencies()


#endregion


#region LOREDs


## Creates a Job using a .json file and stores it in memory for any LORED to use
## Jobs **must** be added before adding LOREDs.
func add_job(job_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_job(job_key, json_path)


## Creates a new LORED using a .json file and stores them in memory. This will
## NOT create a LOREDPrefab. You must create a Stage scene and place LORED
## placeholder nodes in them. Refer to stage_templace.tscn for help :D
func add_lored(lored_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_lored(lored_key, json_path)


## Stops specified LOREDs from working, removes their prefabs, and deletes them
## from memory. If you are replacing the old LOREDs, call this before adding new
## ones. Murdered LOREDs cannot be resurrected.
## NOTE - If `loreds_to_kill` is empty, it will kill every LORED, including
## ones added from other mods.
# idk if this actually matters ## NOTE - This should not be called before kill_stages().
func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_loreds(loreds_to_kill)


## Resets all of the current LOREDs in memory to level 1.
func reset_loreds() -> void:
	get_node("/root/Kit").reset_loreds()


#endregion


#region Stages


## Creates a new Stage using a .json file
func add_stage(stage_key: StringName, json_path: String) -> void:
	get_node("/root/Kit").add_stage(stage_key, json_path)


## Removes Stages from the game.
## NOTE - Does not affect LOREDs who are kept in memory. Deletes Stage UI and
## stats only.
func kill_stages(stages_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_stages(stages_to_kill)


## Must be called once you're done adding Stages and LOREDs
func refresh_stages() -> void:
	get_node("/root/Kit").refresh_stages()


## Resets the statistics of every Stage in memory
func reset_stages() -> void:
	get_node("/root/Kit").reset_stages()


#endregion


#region Upgrades


## Sets all Upgrades in memory to unpurchased
## (except `unlock_upgrades` which unlocks the Upgrades window)
func reset_upgrades() -> void:
	get_node("/root/Kit").reset_upgrades()


#endregion


#endregion


#endregion
