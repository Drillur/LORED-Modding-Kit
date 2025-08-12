extends Node


## Called when the mod is loaded into LORED for the first time
func _ready() -> void:
	pass


#region Kit helper functions


# NOTE These functions are examples of how to use the helper functions of the
# Kit class in LORED. They are designed for modders.

# Feel free to delete this region.


#region Control


#region Signals


## When you write `await await_mods_loaded()`, your code will pause until
## `Kit.signals.mods_loaded` is emitted. That will happen after this and every
## other mod is loaded.
func await_mods_loaded() -> void:
	await get_node("/root/Kit").signals.mods_loaded


#endregion


#region LOREDs


## Stops specified LOREDs from working, removes their prefabs, and deletes them from memory.
## If you are replacing the old LOREDs, call this before adding new ones.
## NOTE - If `loreds_to_kill` is empty, it will kill every LORED, including
## ones added from other mods.
func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	get_node("/root/Kit").kill_loreds(loreds_to_kill)


## Removes 
func kill_stages(_stages_to_kill: Array[StringName] = []) -> void:
	pass

## Creates a new LORED using the provided parameters and stores him in memory.
## You must also create a 
func add_lored(_lored_key: StringName, _lored_data: JSON) -> void:
	pass


#endregion


#endregion


#endregion
