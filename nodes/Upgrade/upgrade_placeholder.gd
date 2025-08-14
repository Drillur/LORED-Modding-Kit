class_name UpgradePlaceholder
extends Panel


#region Region


func _ready() -> void:
	var stage_key: StringName = Upgrade.fetch(name).stage.key
	var stage_is_allowed: bool = true
	
	if Stage.STAGES_UNAVAILABLE_IN_DEMO.has(stage_key) and Main.DEMO:
		stage_is_allowed = false
	
	if stage_is_allowed:
		var parent_node: Node = get_parent()
		var groups: Array[StringName] = get_groups()
		var upgrade_prefab := UpgradePrefab.get_new_prefab()
		upgrade_prefab.upgrade_key = name
		groups = groups.filter(
			func(group: StringName) -> bool:
				return not group.begins_with("_")
		)
		
		await get_owner().ready
		
		parent_node.add_child(upgrade_prefab)
		get_parent().move_child(upgrade_prefab, get_index())
		for group in groups:
			upgrade_prefab.add_to_group(group)
	
	queue_free()
	hide()


#endregion
