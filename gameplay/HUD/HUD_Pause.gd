extends Control
class_name HUDPause


export(Array,Color) var selected_colors

var img
var menu_data = ["resume","reset","exit"]

onready var color = $Main/menu/resume.get("custom_colors/font_color")
onready var labels = $Main/menu.get_children()
onready var menu:MenuManager = MenuManager.new(self,true)

func _ready():
	$Main/level_name.text = LevelManager.get_current_level_name()
	set_process(false)
	visible = false

func do_pause():
	get_tree().paused = true
	img = get_viewport().get_texture().get_data()
	var t = ImageTexture.new()
	t.create_from_image(img)
	$t_rect.rect_scale = Vector2.ONE
	$t_rect.texture = t
	visible = true
	set_process(true)
	_on_cursor_moved(0)

func _process(delta):
	$t_rect.rect_scale = lerp($t_rect.rect_scale, Vector2(0.606,0.475),.1)
	menu.update()

func _on_cursor_moved(index):
	for i in range(labels.size()):
		labels[i].set("custom_colors/font_color",color)
	var i = 0
	while(index == menu._current and get_tree().paused):
#		print("ht: "+str(index))
		if i == 0: i = 1
		else: i = 0
		labels[index].set("custom_colors/font_color",selected_colors[i])
		
		yield(get_tree(),"idle_frame")
		yield(get_tree(),"idle_frame")
		
#	for i in range(2):
#		labels[index].set("custom_colors/font_color",selected_colors[i])
#		if i == 1 and index == menu._current:
#			i = 0
#		else: break

func _on_menu_selected_resume(index):
	print("test")
	set_process(false)
	visible = false
	yield(get_tree().create_timer(.2,true),"timeout")
	get_tree().paused = false

func _on_menu_selected_exit(index):
	get_tree().paused = false
	get_tree().finish()
	
