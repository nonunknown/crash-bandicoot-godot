extends Node


export(Array,AudioStreamSample) var streams = []
var last_stream:int = -1

func emit_step():
	var index = -1
	index = int(rand_range(0,streams.size()-1))
	if index == last_stream:
		emit_step()
		return
	last_stream = index
	var stream = streams[index]
	SoundManager.layer_play(SoundManager.bus_step,stream,get_parent().global_transform.origin)
	pass
