#class_name Kit
extends Node


## A class for useful methods for modders


static var mod_path: String = OS.get_user_data_dir().path_join("mods/")

var signals := SignalBus.new()


#region Control


#region Signals


func emit_mods_loaded() -> void:
	signals.mods_loaded.emit()


func await_mods_loaded() -> void:
	await signals.mods_loaded


#endregion


#region Currency


func currency_add_amount(currency_key: StringName, amount: Variant) -> void:
	Currency.add(currency_key, amount)


func add_currency(currency_key: StringName, json_path: String) -> void:
	Log.pr(add_currency, currency_key)
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		print(" - FileAccess.open failed")
		return
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	Currency.data[currency_key] = json.data
	Currency.new(currency_key)


func reset_currencies() -> void:
	for currency: Currency in Currency.list.values():
		currency.reset(10)


func kill_currencies(currencies_to_kill: Array[StringName] = []) -> void:
	Log.pr(kill_currencies, currencies_to_kill)
	if currencies_to_kill.is_empty():
		for currency_key: StringName in Currency.list.keys():
			currencies_to_kill.append(currency_key)
	for currency_key: StringName in currencies_to_kill:
		Currency.fetch(currency_key).kill()


#endregion


#region LORED


func add_job(job_key: StringName, json_path: String) -> void:
	Log.pr(add_job, job_key)
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
	Log.pr(add_lored, lored_key)
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		print(" - FileAccess.open failed")
		return
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	LORED.data[lored_key] = json.data
	LORED.new(lored_key)


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


#region Stage


func add_stage(stage_key: StringName, json_path: String) -> void:
	Log.pr(add_stage, stage_key)
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
	Log.pr(kill_stages, stages_to_kill)
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


#region Upgrade


func add_upgrade(upgrade_key: StringName, json_path: String) -> void:
	Log.pr(add_upgrade, upgrade_key)
	
	var file := FileAccess.open(json_path, FileAccess.READ)
	if not file:
		Log.err("FileAccess.open failed")
		return
	
	var json_text := file.get_as_text()
	var json := JSON.new()
	json.parse(json_text)
	
	Upgrade.data[upgrade_key] = json.data
	Upgrade.new(upgrade_key)
	
	UpgradeTree.setup_upgrade_count()


func kill_upgrades(upgrades_to_kill: Array[StringName] = []) -> void:
	Log.pr(kill_upgrades, upgrades_to_kill)
	if upgrades_to_kill.is_empty():
		for upgrade_key: StringName in Upgrade.list.keys():
			upgrades_to_kill.append(upgrade_key)
	for upgrade_key: StringName in upgrades_to_kill:
		Upgrade.fetch(upgrade_key).kill()


func reset_upgrades() -> void:
	for upgrade: Upgrade in Upgrade.list.values():
		if upgrade.key == &"unlock_upgrades":
			continue
		upgrade.reset(10)


#endregion


#region Upgrade Tree


func add_upgrade_tree(tree_key: StringName, json_path: String) -> void:
	Log.pr(add_upgrade_tree, tree_key)
	
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
	Log.pr(kill_upgrade_trees, trees_to_kill)
	if trees_to_kill.is_empty():
		for tree_key: StringName in UpgradeTree.list.keys():
			trees_to_kill.append(tree_key)
	for tree_key: StringName in trees_to_kill:
		UpgradeTree.fetch(tree_key).kill()


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
