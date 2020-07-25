extends Control
class_name HUDGameplay

signal increase_crate

var _wumpas:int = 0
func add_wumpas(side:int=1):
	_wumpas += side
	$Container/Wumpas/Label.text = str(_wumpas)

var _lifes:int = 0
func add_lifes(side:int=1):
	_lifes += side
	$Container/Lifes/Label.text = str(_lifes)

var _boxes:int = 0
func update_boxes(side:int=1):
	_boxes += side
	$Container/Boxes/Label.text = str(_boxes)



func _init():
	add_to_group(str(Groups.HUD_GAMEPLAY))
	connect("increase_crate",self,"_on_increase_crate")

func _ready():
	_zero_all_values()
	set_max_boxes()

func set_max_boxes():
	var _max = 0
	for crate in Groups.get_from(Groups.CRATES):
		if crate.destroyable == false: continue
		_max += 1
	$Container/Boxes/MAX.text = "/"+str(_max)
	print(str(_max))

func _zero_all_values():
	_boxes = 0
	_wumpas = 0
	_lifes = 0
	$Container/Boxes/Label.text = str(_boxes)
	$Container/Lifes/Label.text = str(_lifes)
	$Container/Wumpas/Label.text =str(_wumpas)
	
	
func _on_increase_crate():
	
	pass
