class_name LOREDPlaceholder
extends Panel


#region Region


func _ready() -> void:
	var stage_key := LORED.fetch(name).stage.key
	var stage_is_allowed: bool = false
	
	match stage_key:
		&"main2":
			stage_is_allowed = Main.STAGE_2_ENABLED
		&"main3":
			stage_is_allowed = Main.STAGE_3_ENABLED
		&"main4":
			stage_is_allowed = Main.STAGE_4_ENABLED
		_:
			stage_is_allowed = true
	
	if stage_is_allowed:
		var lored_prefab := LOREDPrefab.get_new_prefab()
		lored_prefab.lored_key = name
		
		await get_owner().ready
		
		parent_node.add_child(lored_prefab)
		get_parent().move_child(lored_prefab, get_index())
	
	queue_free()
	hide()


#endregion
