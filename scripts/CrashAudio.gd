extends SmartAudioStream
class_name CrashAudio

enum SAMPLE {dash,jump,spin,step}

func emit_jump():
	play_audio(SAMPLE.jump)

func emit_dash():
	play_audio(SAMPLE.dash)

func emit_spin():
	play_audio(SAMPLE.spin)

func emit_step():
	play_audio(SAMPLE.step)
