extends Control

var menu_data = ["register","restart","exit"]
onready var _menus = [$register,$restart,$exit]
onready var menu:MenuManager = MenuManager.new(self)

func _ready():
	set_process(false)
	pass

func _process(delta):
	menu.update()

func _on_menu_selected_register(enabled):
	set_process(false)
	var online = load("res://gameplay/HUD/OnlineLeader.tscn").instance()
	get_parent().add_child(online)
	online.compare_times(get_parent().time)
	visible = false
	get_parent().get_node("AnimationPlayer").seek(0,true)
	get_parent().get_node("AnimationPlayer").stop()
	
	pass

func _on_menu_selected_restart(enabled):
	set_process(false)
	LevelManager.restart_scene()
	pass

func _on_menu_selected_exit(enabled):
	set_process(false)
	get_tree().quit()
	pass

onready var cursor_pos = $Arrow.rect_position
func _on_cursor_moved(index):
	var m:Label = _menus[index]
	$Arrow.rect_position = m.rect_position - Vector2(50,0)
	
	pass
