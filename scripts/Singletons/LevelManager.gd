extends Node

signal event_restart

const CRATE = preload("res://models/crate/rm_crate.tscn")

var player:Player

func _ready():
	if get_tree().has_group(str(Groups.PLAYER)):
		player = Groups.get_first(Groups.PLAYER)


onready var stream_pop = load("res://Sounds/crate/pop.wav") as AudioStream
func activate_hided_crates(id:int):
	if id < 0: return
	for crate in Groups.get_from(Groups.HIDE):
		if crate.activator_id == id:
			crate.activator.activate()
			SoundManager.layer_play(SoundManager.bus_enemies,stream_pop,crate.global_transform.origin)
			yield(get_tree().create_timer(.4,false),"timeout")

var checkpoint_data = {
	position = Vector3(),
	first_save = false
}
func save_checkpoint():
	checkpoint_data.first_save = true
	checkpoint_data.position = player.global_transform.origin
	for crate in Groups.get_from(Groups.DESTROYABLE):
		var c:Crate = crate
		if c.destroyed:
			c.add_to_group(str(Groups.SAVED))
	

func load_last_checkpoint():
	emit_signal("event_restart")
	player.ressurect()
	player.global_transform.origin = player.initial_pos
	if checkpoint_data.first_save == false: return
	player.global_transform.origin = checkpoint_data.position
	for crate in Groups.get_from(Groups.DESTROYABLE):
		if crate.is_in_group(str(Groups.SAVED)): continue
		crate.event_reenable()
	pass


