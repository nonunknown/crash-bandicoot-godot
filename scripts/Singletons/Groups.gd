extends Node

enum {PLAYER,CRATES,SAVED,DESTROYABLE,C_NITRO,ITEMS,SPIN,HIDE,C_TNT,EXPLOSION,
	HUD_GAMEPLAY
}



func get_first(group:int):
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
