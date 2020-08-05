extends VBoxContainer

var menu_data = ["0","1","2","3","4","5","6","7","8","9","10","11"]
var menu = MenuManager.new(self)
var values_p2 = [256,512,1024,2048,4096,8192,16384]
var values_bool = [true,false]
var values_ms = ["Disabled", "2x", "4x", "8x", "16x"]
var values_filter = ["Disabled", "PCF5", "PCF13"]
var values_res = [Vector2(720,480),Vector2(1280,720)]
var values = [values_p2,values_bool,values_ms,values_filter,values_res]
var options_type = [0,0,3,1,2,1,1,4,2,1]
var default = []
#var default = [256,256,"Disabled",false,"Disabled",false,Vector2(720,480),"Disabled",false]
onready var options_ref = get_children()

func _ready():
	for i in range(options_type.size()):
		default.append(values[ options_type[i] ][0])
	print(default)
	set_process(false)

func _get_text(value:String): return "> %s <" % value

export var initial_color:Color

func _on_cursor_moved(index):
	if index >= 10: return
	var current_option:Array = values[ options_type[index] ]
	var selected = current_option.find(default[index])
	
	while(menu._current == index):
		var moved = int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
		if moved == 1 and (selected + 1 < current_option.size()): selected += 1
		elif moved == -1 and (selected - 1 >= 0 ): selected -= 1
		
		options_ref[index].get_node("value").text = _get_text(str( current_option[selected] ))
		options_ref[index].get_node("text").set("custom_colors/font_color",Color.white)
		yield(get_tree(),"idle_frame")
	print("old default = %s" %str(default[index])) 
	default[index] = current_option[selected]
	print("new default = %s" %str(default[index])) 
	options_ref[index].get_node("text").set("custom_colors/font_color",initial_color)

func _on_menu_selected_10(enable): #go back
	get_parent().get_parent().event_goback_selected()

func _process(delta):
	menu.update()
	
