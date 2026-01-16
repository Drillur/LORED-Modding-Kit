#class_name Kit
extends Node


## A class for useful methods for modders


static var mod_path: String = OS.get_user_data_dir().path_join("mods/")

@export var mod_vars: Dictionary = {} # Mod key: { mod's saved vars }

var signals := SignalBus.new()


func _ready() -> void:
	SaveManager.saving_started.connect(signals.saving_begun.emit)
	SaveManager.loading_ended.connect(signals.loading_finished.emit)
	Main.instance.prestiged.connect(signals.prestiged.emit)


#region Control


func kill_all_else() -> void:
	Prestige._prestige_buffs(10)
	Prestige._prestige_dice(10)


#region Signals


func emit_mods_loaded() -> void:
	Utility.cache_class_paths()
	signals.mods_loaded.emit()
	emit_classes_changed()


func emit_classes_changed() -> void:
	signals.classes_changed.emit()


#endregion


#region Currency


func currency_add_amount(currency_key: StringName, amount: Variant) -> void:
	Currency.add(currency_key, amount)


func currency_set_amount(currency_key: StringName, amount: Variant) -> void:
	Currency.get_amount(currency_key).set_to(amount)


func add_currency(currency_key: StringName, json_path: String) -> void:
	#Log.pr(add_currency, currency_key)
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		print(" - FileAccess.open failed")
		return
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	Currency.data[currency_key] = json.data
	Currency.new(currency_key)


func currency_to_int(currency_key: StringName) -> int:
	return Currency.get_value(currency_key).to_int()


func currency_to_log10(currency_key: StringName) -> float:
	return Currency.get_value(currency_key).to_log()


func currency_get_text(currency_key: StringName) -> String:
	return Currency.get_value(currency_key).get_text()


#region Comparisons


func currency_is_equal_to(currency_key: StringName, n: Variant) -> bool:
	return Currency.get_value(currency_key).is_equal_to(n)


func currency_is_greater_than(currency_key: StringName, n: Variant) -> bool:
	return not currency_is_less_than_or_equal_to(currency_key, n)


func currency_is_greater_than_or_equal_to(currency_key: StringName, n: Variant) -> bool:
	return not currency_is_less_than(currency_key, n)


func currency_is_less_than(currency_key: StringName, n: Variant) -> bool:
	return Currency.get_value(currency_key).is_less_than(n)


func currency_is_less_than_or_equal_to(currency_key: StringName, n: Variant) -> bool:
	return Currency.get_value(currency_key).is_less_than_or_equal_to(n)


#endregion


func currency_get_changed_signal(currency_key: StringName) -> Signal:
	return Currency.get_amount(currency_key).changed


func reset_currencies() -> void:
	for currency: Currency in Currency.list.values():
		currency.reset(10)


func refresh_currencies() -> void:
	Currency.signals.changed.emit()


func kill_currencies(currencies_to_kill: Array[StringName] = []) -> void:
	#Log.pr(kill_currencies, currencies_to_kill)
	if currencies_to_kill.is_empty():
		for currency_key: StringName in Currency.list.keys():
			currencies_to_kill.append(currency_key)
	for currency_key: StringName in currencies_to_kill:
		Currency.fetch(currency_key).kill()


#endregion


#region LORED


func add_job(job_key: StringName, json_path: String) -> void:
	#Log.pr(add_job, job_key)
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		print(" - FileAccess.open failed")
		return
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	Job.data[job_key] = json.data
	Job.new(job_key)


func add_lored(lored_key: StringName, json_path: String) -> void:
	#Log.pr(add_lored, lored_key)
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		print(" - FileAccess.open failed")
		return
	
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	LORED.data[lored_key] = json.data
	
	var class_path: String = Utility.get_class_path(
			LORED.data[lored_key].get("Class", "LORED"))
	load(class_path).new(lored_key)


func kill_loreds(loreds_to_kill: Array[StringName] = []) -> void:
	if loreds_to_kill.is_empty():
		for lored_key: StringName in LORED.list.keys():
			loreds_to_kill.append(lored_key)
	for lored_key: StringName in loreds_to_kill:
		LORED.fetch(lored_key).kill()
	LORED.signals.lored_killed.emit()


func reset_loreds() -> void:
	for lored: LORED in LORED.list.values():
		lored.reset()


#endregion


#region Save


func edit_save_data(mod_key: StringName, data: Variant) -> void:
	mod_vars[mod_key] = data


#endregion


#region Stage


func add_stage(stage_key: StringName, json_path: String) -> void:
	#Log.pr(add_stage, stage_key)
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
	#Log.pr(kill_stages, stages_to_kill)
	if stages_to_kill.is_empty():
		for stage_key: StringName in Stage.list.keys():
			stages_to_kill.append(stage_key)
	for stage_key: StringName in stages_to_kill:
		Stage.fetch(stage_key).kill()
	
	refresh_stages()


func refresh_stages() -> void:
	Stage.signals.stages_changed.emit()


func reset_stages() -> void:
	for stage: Stage in Stage.list.values():
		stage.reset()


#endregion


#region UI


func throw_text_from_node(spawn_node: Node, text: String, icon: Texture2D = null) -> void:
	if icon:
		FlyingText.new_text_with_icon(spawn_node, text, icon)
	else:
		FlyingText.new_text(spawn_node, text)


#endregion


#region Upgrade


func add_upgrade(upgrade_key: StringName, json_path: String) -> void:
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		printerr("FileAccess.open failed")
		return
	
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	Upgrade.data[upgrade_key] = json.data
	
	var class_path: String = Utility.get_class_path(
			Upgrade.data[upgrade_key].get("Class", "Upgrade"))
	load(class_path).new(upgrade_key)


func upgrade_get_times_purchased_signal(currency_key: StringName) -> Signal:
	return Upgrade.fetch(currency_key).times_purchased.changed


func reset_upgrades() -> void:
	for upgrade: Upgrade in Upgrade.list.values():
		if upgrade.key == &"unlock_upgrades":
			continue
		upgrade.reset(10)


func refresh_upgrades() -> void:
	for upgrade: Upgrade in Upgrade.list.values():
		upgrade._init_required_upgrade()


func kill_upgrades(upgrades_to_kill: Array[StringName] = []) -> void:
	#Log.pr(kill_upgrades, upgrades_to_kill)
	if upgrades_to_kill.is_empty():
		for upgrade_key: StringName in Upgrade.list.keys():
			upgrades_to_kill.append(upgrade_key)
	for upgrade_key: StringName in upgrades_to_kill:
		Upgrade.fetch(upgrade_key).kill()


#endregion


#region Upgrade Tree


func add_upgrade_tree(tree_key: StringName, json_path: String) -> void:
	#Log.pr(add_upgrade_tree, tree_key)
	
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		Log.err("FileAccess.open failed")
		return
	
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	UpgradeTree.data[tree_key] = json.data
	UpgradeTree.new(tree_key)


func refresh_trees() -> void:
	UpgradeContainer.check_again__swap_out()


func kill_upgrade_trees(trees_to_kill: Array[StringName] = []) -> void:
	#Log.pr(kill_upgrade_trees, trees_to_kill)
	if trees_to_kill.is_empty():
		for tree_key: StringName in UpgradeTree.list.keys():
			trees_to_kill.append(tree_key)
	for tree_key: StringName in trees_to_kill:
		UpgradeTree.fetch(tree_key).kill()


#endregion


#region Utility


func format_number(number: float) -> String:
	return LoudNumber.format_number(number)


#endregion


#endregion


#region Classes


class SignalBus:
	extends Object
	
	
	@warning_ignore("unused_signal")
	signal mods_loaded
	@warning_ignore("unused_signal")
	signal classes_changed
	@warning_ignore("unused_signal")
	signal saving_begun
	@warning_ignore("unused_signal")
	signal loading_finished
	@warning_ignore("unused_signal")
	signal prestiged


#endregion
