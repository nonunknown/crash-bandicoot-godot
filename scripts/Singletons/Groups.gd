extends Node

enum {PLAYER,CRATES,SAVED,DESTROYABLE,C_NITRO,ITEMS,SPIN,HIDE}

func get_first(group:int):
	return get_tree().get_nodes_in_group(str(group))[0]

func get_from(group:int):
	return get_tree().get_nodes_in_group(str(group))
