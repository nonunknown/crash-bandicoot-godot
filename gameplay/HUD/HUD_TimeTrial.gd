extends Control

export var freeze_color:Color
onready var label:Label = $Label
onready var counter:Label = $Counter

var label_color:Color
var counter_initial_pos:Vector2
var time:float = 0
var stop:bool = false
var stop_time:float = 0
func _ready():
	label_color = label.get_color("font_color")
	counter_initial_pos = counter.rect_position
	pass

func _process(delta):
	if !stop:
		time += delta
		set_timer(time)
	else:
		set_counter()
		stop_time -= delta
		if stop_time <= 0.0: 
			unfreeze()
		pass
	
	if Input.is_action_just_pressed("ui_accept") and !stop:
		freeze(1)
	

func freeze(time:float):
	counter.visible = true
	stop_time = time
	label.set("custom_colors/font_color",freeze_color)
	$sfx.play()
	stop = true
	

func unfreeze():
	counter.visible = false
	counter.rect_position = counter_initial_pos
	label.set("custom_colors/font_color",label_color)
	stop = false
	$sfx.stop()

func set_timer(value):
	var minutes = value / 60;
	var seconds = int(value) % 60;
	var mili = str(value).split(".")
	if mili.size() > 1: mili = str(mili[1])
	else: mili = "0"
	
	label.text = "%02d:%02d:%06s" % [minutes,seconds,mili]

func set_counter():
	var secs = stop_time 
	counter.text = "-%02f" % secs
	counter.rect_position += Vector2.UP * ( sin(stop_time) )
