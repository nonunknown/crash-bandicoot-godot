extends VBoxContainer

var menu_data = ["new","load","options","exit"]
onready var menus = get_children()
onready var initial_color = menus[0].get("custom_colors/font_color")
var menu:MenuManager = MenuManager.new(self)

func _ready():
	
	_on_cursor_moved(0)
	set_process(false)
#	OS.window_size = Vector2(720,480)
	

func _process(delta):
	menu.update()


onready var stream_moved = load("res://modules/main_menu/sounds/cursor_moved.ogg") as AudioStream


func load_warp_room():
	set_process(false)
	AdvancedBackgroundLoader.preload_scene("res://scenes/warp_test.tscn")
	while !AdvancedBackgroundLoader.can_change:
		yield(get_tree().create_timer(.5,false),"timeout")
	AdvancedBackgroundLoader.change_scene_to_preloaded()
	

func _on_menu_selected_new(enable):
	load_warp_room()
	pass

func _on_menu_selected_load(enable):
	SaveManager.load_game_on_start = true
	load_warp_room()
	pass

func _on_menu_selected_exit(enable):
	get_tree().quit(0)

func _on_menu_selected_options(enable):
	get_parent().get_parent().event_options_selected()

func _on_cursor_moved(index):
	get_parent().get_parent().get_node("sfx2").stream = stream_moved
	get_parent().get_parent().get_node("sfx2").play()
	for i in range(menus.size()):
		menus[i].set("custom_colors/font_color",initial_color)
		if i == index:
			menus[i].set("custom_colors/font_color",Color.white)
	while(menu._current == index):
		if !is_processing(): break
		menus[index].set("custom_colors/font_color",Color.white)
		yield(get_tree(),"idle_frame")
		yield(get_tree(),"idle_frame")
		menus[index].set("custom_colors/font_color",initial_color)
		yield(get_tree(),"idle_frame")
		yield(get_tree(),"idle_frame")
		
		
