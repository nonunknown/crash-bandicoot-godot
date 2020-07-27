class_name MenuManager

var _amount:int
var _reset_on_last:bool
var _current:int
var _target:Node
var _last:int
var enable = {}
func _init(target:Node,reset_on_last:bool = false, start:int = 0) -> void:
	_target = target
	_amount = target.menu_data.size()
	_reset_on_last = reset_on_last
	_current = start
	_last = start
	for i in range( target.menu_data.size()) :
		enable[i] = true

func disable_option(index):
	enable[index] = false

func update():
	var move = int(Input.is_action_just_pressed("ui_up")) - int(Input.is_action_just_pressed("ui_down"))
	if move > 0:
		if _current -1 < 0:
			if _reset_on_last:
				_current = _amount - 1
		else: _current -= 1
	elif move < 0:
		if _current + 1 > _amount -1:
			if _reset_on_last:
				_current = 0
		else: _current += 1
	if !move == 0 and _last != _current:
			_target.call_deferred("_on_enter_"+_target.menu_data[_current])
			_target.call_deferred("_on_cursor_moved",_current)
	elif Input.is_action_just_pressed("ui_select"):
		_target.call_deferred("_on_menu_selected_"+_target.menu_data[_current],enable[_current])
	_last = _current
	
