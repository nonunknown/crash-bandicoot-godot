extends Crate
class_name CrateHide

func _init():
	._init()
	add_to_group(str(Groups.HIDE))
	

export var hided_activator_id = -1
export var activator_id = -1
export var crate:PackedScene
onready var stream_pop = load("res://Sounds/crate/pop.wav") as AudioStream
var child_crate:Crate
func enable():
	child_crate = crate.instance()
	$Crate.add_child(child_crate)
	if hided_activator_id > -1:
		child_crate.activator_id = hided_activator_id
	SoundManager.layer_play(SoundManager.bus_crates,stream_pop, global_transform.origin)
	$Model.visible = false
	pass

func event_reenable():
	if child_crate != null:
		child_crate.queue_free()
	$Model.visible = true
	pass
