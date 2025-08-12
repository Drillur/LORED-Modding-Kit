@tool
class_name Kit
extends Node


## The official LORED modding kit


static var signals := SignalBus.new()

## In LORED, this holds any scripts added by mods
## (except for main.gd, which is cached elsewhere when the mod is loaded)
static var cached_scripts: Dictionary[StringName, Dictionary]


#region Static


#region Init


static func _static_init() -> void:
	if not Engine.is_editor_hint():
		return
	print("LORED Modding Kit _static_init()")
	_check_if_exporting_self()


## If you have not added LORED-Modding-Kit/* to your exluded files field in
## your export settings, this will print an error message.
static func _check_if_exporting_self() -> bool:
	var config := ConfigFile.new()
	var error := config.load("res://export_presets.cfg")
	if error == OK:
		var text: String = config.encode_to_text()
		if not text.contains("LORED-Modding-Kit/*"):
			printerr("Please add LORED-Modding-Kit/* to the excluded files/folders field in your export settings (resource tab).")
			return false
		return true
	return false


#endregion


#region Signals


static func emit_mods_loaded() -> void:
	signals.mods_loaded.emit()


#endregion


#region Control


#region LOREDs


## Stops specified (or all, if none specified)
## LOREDs from working, removes their prefabs, and deletes them from memory.
## If you are replacing the old LOREDs, call this before adding new ones.
static func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	var expression := Expression.new()
	expression.parse(
		"if loreds_to_kill.is_empty():
			for lored_key: StringName in LORED.list.keys():
				loreds_to_kill.append(lored_key)
		for lored_key: StringName in loreds_to_kill:
			LORED.fetch(lored_key).kill()
		LORED.signals.emit_lored_killed()",
		["loreds_to_kill"]
	)
	expression.execute(loreds_to_kill)
	


## Removes 
static func kill_stages(_stages_to_kill: Array[StringName] = []) -> void:
	pass

## Creates a new LORED using the provided parameters and stores him in memory.
## You must also create a 
static func add_lored(_lored_key: StringName, _lored_data: JSON) -> void:
	pass


#endregion


#endregion


#region Get Values


## If appropriate, returns your mod's main.tscn if you pass in your own key.
static func get_main_scene(key: StringName) -> PackedScene:
	return Mod.mod_packed_scenes.get(key)


#endregion


#endregion


#region Ready


func _ready() -> void:
	_repeatedly_check_if_exporting_self()


func _repeatedly_check_if_exporting_self() -> void:
	while true:
		if _check_if_exporting_self():
			return
		await get_tree().create_timer(20.0).timeout


#endregion


#region Utility


@warning_ignore("unused_private_class_variable")
@export var __create_info_json: bool = false:
	set = _create_info_json

@warning_ignore("unused_private_class_variable")
@export var __create_lored_data_json: bool = false:
	set = _create_lored_data_json


func _create_info_json(_val: bool) -> void:
	const BASE_DATA: Dictionary = {
		"key": "unique_identifier",
		"author": "your_username",
		"display name": "ModName",
		"description": "short_summary_of_mods_effects",
		"color": "#hex_color_for_your_mod",
		"affects save": false,
	}
	
	if not _val:
		return
	
	var file = FileAccess.open("res://info.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	print("Created res://info.json! Move it to your mod directory.")
	print("Explanations of the info data fields:")
	print(" - Bbcode must not be used in this file.")
	print(" - key: The mod's unique identifier. If it conflicts with another mod, it may be overwritten. LORED prepends the author text before the key to help make it more unlikely.")
	print(" - author: The mod's author.")
	print(" - display name: The name the players will see in-game.")
	print(" - description: A short summary of the mod's effects.")
	print(" - color: Various UI elements will use this color.")
	print(" - affects save: Set to true if the mod is expected to affect the save in any way.")


func _create_lored_data_json(_val: bool) -> void:
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
	
	if not _val:
		return
	
	var file = FileAccess.open("res://new_lored.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	print("Created res://new_lored.json! Rename it and change the values.")
	print("Explanations of LORED data fields:")
	print(" - Key: The LORED's unique identifier.")
	print(" - Title: The LORED's official job title.")
	print(" - Name: The LORED's actual name.")
	print(" - Icon: Use the filename of the icon you want to use. Do not include the extension or path.")
	print(" - Color: The hex code for the LORED's color.")
	print(" - Descrption: Optional - some flavor text")
	print(" - Favorite Thing: Optional - more flavor text")
	print(" - Class: You may create your own class which extends LORED to add custom class behavior.")
	print(" - Stage: The key of the Stage that the LORED belongs to. If you add a custom Stage, set the key to that Stage's key.")
	print(" - Price: The base price for leveling up the LORED.")
	print(" - Price Increase: The amount the LORED's price increases by per level.")
	print(" - Maximum Expected Level: This determines how high LORED will cache its prices for quick purchasing.")
	print(" - Jobs: The starting job list for the LORED. If you want multiple, separate by a comma and a space. Example: growth, growth2")
	print(" - Primary Jobs: The job which affects currency rates. Growth only has 'growth' for this field. growth2 is not counted for rates.")
	print(" - Primary Currencies: The currencies which are displayed on the LORED HUD. If there are multiple, they will be cycled every 3 seconds.")
	print(" - Autobuyer Level: The level required to unlock the LORED's autobuyer. ")


#endregion


#region Classes


class SignalBus:
	extends Object
	
	
	@warning_ignore("unused_signal")
	signal mods_loaded ## Emitted by Mod.load_enabled_mods() when done loading mods
	@warning_ignore("unused_signal")
	signal classes_changed ## If you add any custom Classes, they cannot be used until this emits.


#endregion
