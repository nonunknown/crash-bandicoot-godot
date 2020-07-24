extends Crate
class_name CrateActivator


export var activator_id:int = -1

var activated:bool = false

onready var stream_sfx = load("res://Sounds/crate/activator.wav") as AudioStream

func event_destroy(player):
	if activated: return
	activated = true
	print("test")
	animation.play("Smash")
	SoundManager.layer_play(SoundManager.bus_step,stream_sfx,global_transform.origin)
	LevelManager.activate_hided_crates(activator_id)
#	$Area/Ca ollisionShape.disabled = true
#	$Area/Ca ollisionShape.disabled = true
	pass

func event_reenable():
	.event_reenable()
	activated = false
