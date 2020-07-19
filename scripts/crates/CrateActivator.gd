extends Crate
class_name CrateActivator

export var activator_id:int = -1

onready var stream_sfx = load("res://Sounds/crate/activator.wav") as AudioStream
func event_destroy(player):
	print("test")
	animation.play("Smash")
	SoundManager.layer_play(SoundManager.bus_crates,stream_sfx,global_transform.origin)
	LevelManager.activate_hided_crates(activator_id)
	$Area/CollisionShape.disabled = true
	pass
