extends Control
class_name HUDTimeTrial
export var freeze_color:Color
onready var label:Label = $Label
onready var counter:Label = $Counter
onready var fast:Label = $Fast
var label_color:Color
var counter_initial_pos:Vector2
var time:float = 0
var stop:bool = false
var stop_time:float = 0
var advance_time:float = 0

func _ready():
	label_color = label.get_color("font_color")
	counter_initial_pos = counter.rect_position
	
	pass

func _enter_tree():
	add_to_group(str(Groups.TIME_TRIAL))
	LevelManager.connect("event_level_finished",self,"on_level_finished")

func _process(delta):
	if !stop:
		time += delta
		set_timer(time)
	else:
		set_counter()
		stop_time -= delta
#		$sfx.pitch_scale = clamp(stop_time/3,0,1)#lerp($sfx.pitch_scale,.3,stop_time/1)
		if stop_time <= 0.0: 
			unfreeze()
		pass
	
	if advance_time > 0:
		time += delta
		advance_time -= delta
#		$sfx.pitch_scale = lerp($sfx.pitch_scale,2,delta)
		update_advance()
		set_timer(time)
	elif advance_time < 0:
		fast.visible = false
		if $sfx.pitch_scale > 1.5:
			$sfx.stop()
		
#	if Input.is_action_just_pressed("ui_accept") and !stop:
#		freeze(1)
#	if Input.is_action_just_pressed("ui_up"):
#		advance(3)
#	elif Input.is_action_just_pressed("ui_down"):
#		freeze(-3)
##

func freeze(time:float):
	time = abs(time)
	counter.visible = true
	stop_time += time
	label.set("custom_colors/font_color",freeze_color)
	$sfx.pitch_scale = .8
	$sfx.play()
	stop = true
	
func advance(time:float):
	$sfx.pitch_scale = 2
	$sfx.play()
	fast.visible = true
	advance_time += time
	

func update_advance():
	fast.text = "+%f" % advance_time
	fast.rect_position += Vector2.RIGHT * ( -cos(advance_time) * 0.5 )


func unfreeze():
	counter.visible = false
	counter.rect_position = counter_initial_pos
	label.set("custom_colors/font_color",label_color)
	stop = false
	if $sfx.pitch_scale < 1.5:
		$sfx.stop()

func set_timer(value):
	var minutes = value / 60;
	var seconds = int(value) % 60;
	var mili = str(value).split(".")
	if mili.size() > 1: mili = str(mili[1])
	else: mili = "0"
	
	label.text = "%02d:%02d:%06d" % [minutes,seconds,float(mili) ]

func set_counter():
	var secs = stop_time 
	counter.text = "-%02f" % secs
	counter.rect_position += Vector2.UP * ( sin(stop_time) * 0.4 )

func on_level_finished():
	print("Called time")
	set_process(false)
	$AnimationPlayer.play("Finish")
