extends Node

#NO_TT - No Time trial group (will no being turned into a time trial crate)

enum {PLAYER,CRATES,SAVED,DESTROYABLE,C_NITRO,ITEMS,SPIN,HIDE,C_TNT,EXPLOSION,
	HUD_GAMEPLAY,TIME_TRIAL,NO_TT
}



func get_first(group:int):
	if get_tree().get_nodes_in_group(str(group)) == []:
		return null
	else:
		return get_tree().get_nodes_in_group(str(group))[0]

func try_get_first(group:int) -> Node:
	var arr = get_tree().get_nodes_in_group(str(group))
	if arr.empty(): return null
	else: return arr[0]

func get_from(group:int):
	return get_tree().get_nodes_in_group(str(group))

func connect_to_group_signal(group:int,signall:String, target:Node, function:String):
	var arr = get_tree().get_nodes_in_group(str(group))
	if arr.size() <= 0: 
		return
	else:
		arr[0].connect(signall, target, function)

func is_in_one_these_groups(target:Node, groups:Array) -> bool:
	for group in groups:
		if target.is_in_group(str(group)):
			return true
	return false
	
