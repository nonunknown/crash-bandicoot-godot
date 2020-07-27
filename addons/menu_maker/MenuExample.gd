extends Node

var menu_data = ["start","exit"]
#											TARGET , When on last move to begin, menu_data to start selected
onready var menu:MenuManager = MenuManager.new(self, false, 1)

func _process(delta):
	menu.update()

func _on_menu_selected_start():
	print("selected start")
	pass

func _on_menu_selected_exit():
	print("selected exit")
	pass

func _on_enter_start():
	print("moved to start")
	cursor_moved()
	pass

func _on_enter_exit():
	print("moved to exit")
	cursor_moved()
	pass

func cursor_moved():
	print("play_sound")
	
	pass
