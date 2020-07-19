extends Node

var bus_player:AudioStreamPlayer3D
var bus_step:AudioStreamPlayer3D
var bus_enemies:AudioStreamPlayer3D
var bus_crates:AudioStreamPlayer3D

func _enter_tree():
	var a = load("res://AudioStreamPlayer.tscn").instance()
	add_child(a)
	bus_player = a.get_child(0)
	bus_step = a.get_child(1)
	bus_enemies = a.get_child(2)
	bus_crates = a.get_child(3)
	bus_player.play()

func layer_play(bus:AudioStreamPlayer3D,stream:AudioStream,position:Vector3):
	bus.global_transform.origin = position
	bus.stream = stream
	bus.play()



func _ready():
	pass # Replace with function body.
