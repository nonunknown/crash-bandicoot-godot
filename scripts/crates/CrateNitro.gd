extends Crate
class_name CrateNitro

onready var stream_hop = load("res://Sounds/crate/nitro_hop.wav") as AudioStream
var stop_hop:bool = false
func _ready():
	stream_destroy = load("res://Sounds/crate/nitro_exposion.wav") as AudioStream
	start_hop()

func start_hop():
	var random:float = rand_range(3,5)
	yield(get_tree().create_timer(random,false),"timeout")
	if stop_hop: return
	SoundManager.layer_play(SoundManager.bus_crates,stream_hop,global_transform.origin)
	$AnimationPlayer.play("hop")
	start_hop()

func event_destroy(player:Player):
	stop_hop = true
	SoundManager.layer_play(SoundManager.bus_crates,stream_destroy,global_transform.origin)
	$CollisionShape.disabled = true
	$Model.visible = false
	particle.emitting = true
	$Area/CollisionShape.disabled = true
	pass

func event_reenable():
	.event_reenable()
	stop_hop = false
	start_hop()
	
func _on_Area_entered(area):
	event_destroy(area.get_parent())
