extends Node

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_F1:
			reset_all_crates()

func reset_all_crates():
	print("GOD SAYS: Reset all stuff")
	var arr = ["C_CRATE","I_ITEM"]
	for group in arr:
		var g = get_tree().get_nodes_in_group(group)
		for stuff in g:
			stuff.event_reenable()
