extends Crate
class_name CrateActivator


export var to_activate_id:int = 0
var activated:bool = false

export var mat_iron:SpatialMaterial 

onready var stream_sfx = load("res://Sounds/crate/activator.wav") as AudioStream
onready var cube:MeshInstance = $Model/crate/Armature/Skeleton/Cube

func event_destroy(player):
	if activated: return
	activated = true
	print("test")
	cube.material_override = mat_iron
	animation.play("Smash")
	$P_I.emitting = true
	SoundManager.layer_play(SoundManager.bus_crates,stream_sfx,global_transform.origin)
	LevelManager.activate_hided_crates(to_activate_id)
	if player != null:
		if player.global_transform.origin.y > global_transform.origin.y and !player.is_spinning:
			player.machine.change_state(2) #force restart jump state
			player.action_jump(1) # 1 means jump higher
	pass

func event_reenable():
	activated = false
	cube.material_override = null
	
	.event_reenable()
