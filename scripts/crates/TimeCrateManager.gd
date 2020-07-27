class_name TimeCrateManager

var _target:Node = null
var path_top = "res://textures/crate/rare/boxes-time?-top.png"
var path_side = "res://textures/crate/rare/boxes-time-?.png"

func _init(target:Node):
	_target = target

func activate_time_behavior(custom_time:float = -100):
	if custom_time > -10: _target.time = custom_time
	if _target.time < -3 or _target.time > 3: 
		push_error("Invalid Time Crate, value mus be -3>=N<=3")
		return
	var top
	var side
	var top_path
	var side_path
	if _target.time > 0:
		top_path = path_top.replace("?","-plus")
		side_path = path_side.replace("?","plus-%d" % _target.time)
		top = load(top_path) as Texture
		side = load(side_path) as Texture
		
		pass
	else:
		top_path = path_top.replace("?","")
		side_path = path_side.replace("?",str(abs(_target.time)))
		top = load(top_path) as Texture
		if _target.time == 0:
			side = top
		else:
			side = load(side_path) as Texture
		pass
	print("from crate: %s, value: %d top is:\n%s,side is: %s" % [_target.name,_target.time, top_path, side_path])
	_target.get_node("Model").change_texture(side,top)

func event_destroy():
	if _target.time == 0: return
	var time_trial:HUDTimeTrial =  Groups.get_first(Groups.TIME_TRIAL)
	if _target.time > 0: time_trial.advance(_target.time)
	else: time_trial.freeze(_target.time)

func _on_event_start_tt():
	activate_time_behavior()
	pass
