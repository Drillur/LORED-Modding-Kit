#class_name Kit
extends Node


## A class for useful methods for modders


const PATH: String = "res://groups/mod/LORED-Modding-Kit/"

var signals := SignalBus.new()

## In LORED, this holds any scripts added by mods
## (except for main.gd, which is cached elsewhere when the mod is loaded)
var cached_scripts: Dictionary[StringName, Dictionary]


#region Ready


func _ready() -> void:
	if Engine.is_editor_hint():
		_create_info_json()
		_create_lored_data_json()


#endregion


#region Utility


func _create_info_json() -> void:
	const BASE_DATA: Dictionary = {
		"key": "unique_identifier",
		"author": "your_username",
		"display name": "ModName",
		"description": "short_summary_of_mods_effects",
		"color": "#hex_color_for_your_mod",
		"affects save": false,
	}
	
	var info_json_path: String = PATH.path_join("templates/info.json")
	if ResourceLoader.exists(info_json_path):
		return
	
	var file := FileAccess.open(info_json_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	#print(" - Bbcode must not be used in this file.")
	#print(" - key: The mod's unique identifier. If it conflicts with another mod, it may be overwritten. LORED prepends the author text before the key to help make it more unlikely.")
	#print(" - author: The mod's author.")
	#print(" - display name: The name the players will see in-game.")
	#print(" - description: A short summary of the mod's effects.")
	#print(" - color: Various UI elements will use this color.")
	#print(" - affects save: Set to true if the mod is expected to affect the save in any way.")


func _create_lored_data_json() -> void:
	const BASE_DATA: Dictionary = {
		"Key": "iron",
		"Title": "Iron",
		"Name": "Will",
		"Icon": "iron",
		"Color": "#12e3ff",
		"Description": "Wants everyone to succeed.",
		"Favorite Thing": "Pizza parties!",
		"Class": "LORED",
		"Stage": "main1",
		"Price": "9 stone, 8 copper",
		"Price Increase": 3.0,
		"Maximum Expected Level": 1000,
		"Jobs": "iron",
		"Primary Jobs": "iron",
		"Primary Currencies": "iron",
		"Autobuyer Level": 20,
	}
	
	var lored_template_path: String = PATH.path_join("templates/lored_template.json")
	if ResourceLoader.exists(lored_template_path):
		return
	
	var file := FileAccess.open(lored_template_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	#print(" - Key: The LORED's unique identifier.")
	#print(" - Title: The LORED's official job title.")
	#print(" - Name: The LORED's actual name.")
	#print(" - Icon: Use the filename of the icon you want to use. Do not include the extension or path.")
	#print(" - Color: The hex code for the LORED's color.")
	#print(" - Descrption: Optional - some flavor text")
	#print(" - Favorite Thing: Optional - more flavor text")
	#print(" - Class: You may create your own class which extends LORED to add custom class behavior.")
	#print(" - Stage: The key of the Stage that the LORED belongs to. If you add a custom Stage, set the key to that Stage's key.")
	#print(" - Price: The base price for leveling up the LORED.")
	#print(" - Price Increase: The amount the LORED's price increases by per level.")
	#print(" - Maximum Expected Level: This determines how high LORED will cache its prices for quick purchasing.")
	#print(" - Jobs: The starting job list for the LORED. If you want multiple, separate by a comma and a space. Example: growth, growth2")
	#print(" - Primary Jobs: The job which affects currency rates. Growth only has 'growth' for this field. growth2 is not counted for rates.")
	#print(" - Primary Currencies: The currencies which are displayed on the LORED HUD. If there are multiple, they will be cycled every 3 seconds.")
	#print(" - Autobuyer Level: The level required to unlock the LORED's autobuyer.")


#endregion


#region Control


#region Signals


func emit_mods_loaded() -> void:
	signals.mods_loaded.emit()


func await_mods_loaded() -> void:
	await signals.mods_loaded


#endregion


#region Stages


func add_stage(stage_key: StringName, json_path: String) -> void:
	print("add_stage()")
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		print("FileAccess.open failed")
		return
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	Stage.data[stage_key] = json.data
	Stage.new(stage_key)


func kill_stages(stages_to_kill: Array[StringName] = []) -> void:
	if stages_to_kill.is_empty():
		for stage_key: StringName in Stage.list.keys():
			stages_to_kill.append(stage_key)
	for stage_key: StringName in stages_to_kill:
		Stage.fetch(stage_key).kill()
	Stage.signals.stages_changed.emit()


func refresh_stages() -> void:
	Stage.signals.stages_changed.emit()


#endregion


#region LOREDs


func add_lored(lored_key: StringName, json_path: String) -> void:
	print("add_lored()")
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		print("FileAccess.open failed")
		return
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	LORED.data[lored_key] = json.data
	LORED.new(lored_key)
	LOREDContainer.instance._swap_out_lored_placeholders()


func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	if loreds_to_kill.is_empty():
		for lored_key: StringName in LORED.list.keys():
			loreds_to_kill.append(lored_key)
	for lored_key: StringName in loreds_to_kill:
		LORED.fetch(lored_key).kill()
	LORED.signals.lored_killed.emit()


#endregion


#endregion


#region Classes


class SignalBus:
	extends Object
	
	
	@warning_ignore("unused_signal")
	signal mods_loaded ## Emitted by Mod.load_enabled_mods() when done loading mods
	@warning_ignore("unused_signal")
	signal classes_changed ## If you add any custom Classes, they cannot be used until this emits.


#endregion
