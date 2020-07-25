class_name ActivatorCrateManager

var _activator_id:int = -1
var target:Spatial = null
var ps_crate:PackedScene = load("res://resources/crate/HideCrate.tscn")
var crate_hided:Spatial
onready var stream_pop = load("res://Sounds/crate/pop.wav") as AudioStream

func _init(activator_id:int,target:Spatial):
	if activator_id < 0: 
		push_error("Activator id cant be less than 0")
		return
	self.target = target
	configure()
	pass

func configure():
	crate_hided = ps_crate.instance()
	target.get_parent().call_deferred("add_child",crate_hided)
	target.add_to_group(str(Groups.HIDE))
	yield(target.get_tree(),"idle_frame")
	crate_hided.global_transform.origin = target.global_transform.origin
	target.global_transform.origin += Vector3.UP * 1000
	pass

func activate():
	target.global_transform.origin = crate_hided.global_transform.origin
	crate_hided.global_transform.origin += Vector3.UP * 1000
	print("HELLO WORLD")

func event_reenable():
	crate_hided.global_transform.origin = target.global_transform.origin
	target.global_transform.origin += Vector3.UP * 1000
