extends AudioStreamPlayer3D


export(Array,AudioStreamSample) var streams = []
var last_stream:int = -1

func emit_step():
	var index = -1
	index = int(rand_range(0,streams.size()-1))
	if index == last_stream:
		emit_step()
		return
	last_stream = index
	stream = streams[index]
	play()
	pass
