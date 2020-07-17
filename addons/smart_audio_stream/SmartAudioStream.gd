extends AudioStreamPlayer3D
class_name SmartAudioStream

#This class let the user play as many audios as he wants without interruptions/cut in the middle


export(int) var initial_streams = 2
export(Array, AudioStreamSample) var samples
var _audios:Array = []

func _ready():
	for i in range(initial_streams): # create initial audios 2 streams
		_create_stream(false)
	for audio in _audios:
		add_child(audio)

func play_audio(sample_idx:int):
	for i in range(_audios.size()):
		var a:AudioStreamPlayer3D = _audios[i]
		if a.playing:
			if i+1 == _audios.size():
				_create_stream()
				_play_last_stream(sample_idx)
				break
			else: continue
		else:
			a.stream = samples[sample_idx]
			a.play()
			#print_debug("playing sample: "+str(sample_idx) + " from AudioStream: "+str(i))
			break

func _create_stream(add_child:bool=true):
	var audio = duplicate()
	audio.set_script(null)
	audio.name = "SFX"
	_audios.append(audio)
	if (add_child): add_child(audio)
	pass

func _play_last_stream(sample_idx):
	var a = _audios[_audios.size()-1]
	a.stream = samples[sample_idx]
	a.play()
	#print_debug("playing sample: "+str(sample_idx) + " from AudioStream: "+str(_audios.size()-1))
	pass

