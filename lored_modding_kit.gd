@tool
class_name Kit
extends Node


## The official LORED modding kit


static var signals := SignalBus.new()

## In LORED, this holds any scripts added by mods
## (except for main.gd, which is cached elsewhere when the mod is loaded)
static var cached_scripts: Dictionary[StringName, Dictionary]


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
		if not text.contains("LORED-Moddking-Kit/*"):
			printerr("Please add LORED-Moddking-Kit/* to the excluded files/folders field in your export settings (resource tab).")
			return false
		return true
	return false


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
@export var _create_info_json: bool = false:
	set = create_info_json

@warning_ignore("unused_private_class_variable")
@export var _create_lored_data_json: bool = false:
	set = create_lored_data_json


func create_info_json(_val: bool) -> void:
	const BASE_DATA: Dictionary = {
		"key": "short_identifier",
		"affects save": false,
		"display name": "ModName",
		"author": "your_username",
		"description": "short_summary_of_mods_effects",
		"color": "#hex_color_for_your_mod",
	}
	
	if not _val:
		return
	
	var file = FileAccess.open("res://info.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	print("Created res://info.json! Move it to your mod directory.")


func create_lored_data_json(_val: bool) -> void:
	const BASE_DATA: Dictionary = {
		"Key": "iron",
		"Title": "Iron",
		"Class": "LORED",
		"Name": "Will",
		"Stage": 1,
		"Icon": "iron (filename without extension of icon)",
		"Primary Currencies": "iron (if you want multiple: growth, juice)",
		"Price": "9 stone, 8 copper",
		"Price Increase": 3.0,
		"Maximum Expected Level": 1000,
		"Jobs": "iron (starting jobs. growth example: growth, growth2)",
		"Primary Jobs": "iron (used for rate calculation & offline earnings)",
		"Color": "#12e3ff (also accepts: 0.07, 0.89, 1)",
		"Autobuyer Level": 20,
		"Favorite Thing": "Pizza parties!",
		"Description": "Wants everyone to succeed.",
	}
	
	if not _val:
		return
	
	var file = FileAccess.open("res://new_lored.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	print("Created res://new_lored.json! Move it to your mod directory.")


#endregion


#region Methods which are overriden in LORED


#region Signals


static func emit_mods_loaded() -> void:
	pass


#endregion


#region Control


#region LOREDs


## Stops specified (or all, if none specified)
## LOREDs from working, removes their prefabs, and deletes them from memory.
## If you are replacing the old LOREDs, call this before adding new ones.
static func kill_loreds(_loreds_to_kill: Array[StringName] = []) -> void:
	pass


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
static func get_main_scene(_key: StringName) -> PackedScene:
	return null


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
