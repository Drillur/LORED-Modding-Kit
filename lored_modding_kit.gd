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
	print("LORED Modding Kit _static_init()")
	_check_if_exporting_self()


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
		await get_tree().create_timer(60.0).timeout


#endregion


#region Signals


static func emit_mods_loaded() -> void:
	signals.mods_loaded.emit()


#endregion


#region Control


static func cache_script(mod_key: StringName, script_path: String) -> void:
	var list: Dictionary = cached_scripts.get_or_add(mod_key, {})
	if not list.has(script_path):
		var script: GDScript = load(script_path)
		if script:
			list[script_path] = script
			print("%s - Script cached successfully! (%s)" % [mod_key, script_path])
		else:
			print("%s - Script caching failed. Could the path be wrong? %s" % [mod_key, script_path])


#region LOREDs


## Stops specified (or all, if none specified)
## LOREDs from working and removes their prefabs.
static func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	if loreds_to_kill.is_empty():
		for lored_key: StringName in LORED.list.keys():
			loreds_to_kill.append(lored_key)
	for lored_key: StringName in loreds_to_kill:
		LORED.fetch(lored_key).kill()
	LORED.signals.emit_lored_killed()


#endregion


#endregion


#region Get Values


## Returns the PackedScene of `key` which was loaded by LORED, or null
static func get_main_scene(key: StringName) -> PackedScene:
	return Mod.mod_packed_scenes.get(key)


#endregion


#region Utility


@export var _create_info_json: bool = false:
	set = create_info_json
@export var _create_lored_data_json: bool = false:
	set = create_lored_data_json


func create_info_json(val: bool) -> void:
	const BASE_DATA: Dictionary = {
		"key": "short_identifier",
		"affects save": false,
		"display name": "ModName",
		"author": "your_username",
		"description": "short_summary_of_mods_effects",
		"color": "#hex_color_for_your_mod",
	}
	var file = FileAccess.open("res://info.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	print("Created res://info.json! Move it to your mod directory.")


func create_lored_data_json(val: bool) -> void:
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
	var file = FileAccess.open("res://new_lored.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(BASE_DATA, "\t", false))
	print("Created res://new_lored.json! Move it to your mod directory.")


#endregion


#region Classes


class SignalBus:
	extends Object
	
	
	signal mods_loaded ## Emitted by Mod.load_enabled_mods() when done loading mods


#endregion
