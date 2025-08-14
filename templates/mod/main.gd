extends Node


## Called when the mod is loaded into LORED for the first time
func _ready() -> void:
	pass


#region Kit helper functions


# NOTE These are examples of how to use the helper functions of the
# Kit class in LORED. They are designed for modders.

# Feel free to delete this region.


#region Examples


func remove_everything() -> void:
	kill_loreds()
	kill_stages()


## Unchanged, this won't work if you call it
func add_custom_stages_and_new_loreds() -> void:
	remove_everything()
	
	add_stage(&"new_stage_key", "path_to_stage.json")
	
	add_lored(&"schlonky", "res://mod_name/loreds/schlonky_data.json")
	add_lored(&"wonky", "res://mod_name/loreds/wonky_data.json")
	add_lored(&"fronky", "res://mod_name/loreds/fronky_data.json")
	add_lored(&"scronky", "res://mod_name/loreds/scronky_data.json")
	
	refresh_stages()


#endregion


#region Control


#region Signals


## When you write `await await_mods_loaded()`, your code will pause until
## `Kit.signals.mods_loaded` is emitted. That will happen after this and every
## other mod is loaded.
func await_mods_loaded() -> void:
	await get_node("/root/Kit").signals.mods_loaded


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


#endregion


#region LOREDs


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


#endregion


#endregion


#endregion
