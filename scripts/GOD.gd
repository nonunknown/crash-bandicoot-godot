extends Node

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_F1:
			reset_all_crates()
		elif event.pressed and event.scancode == KEY_F2:
			print("GOD Says: Got a checkpoint")
			LevelManager.save_checkpoint()
		elif event.pressed and event.scancode == KEY_F3:
			print("GOD Says: Load a checkpoint")
			LevelManager.load_last_checkpoint()

func reset_all_crates():
	print("GOD SAYS: Reset all stuff")
	var arr = [str(Groups.CRATES),str(Groups.ITEMS)]
	for group in arr:
		var g = get_tree().get_nodes_in_group(group)
		for stuff in g:
			stuff.event_reenable()
