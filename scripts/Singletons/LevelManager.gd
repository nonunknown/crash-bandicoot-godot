extends Node

const CRATE = preload("res://models/crate/rm_crate.tscn")

var player:Player

func _ready():
	player = Groups.get_first(Groups.PLAYER)

func activate_hided_crates(id:int):
	if id < 0: return
	for crate in Groups.get_from(Groups.HIDE):
		if crate.activator_id == id:
			crate.enable()
		yield(get_tree().create_timer(.5,false),"timeout")

var checkpoint_data = {
	position = Vector3()
}
func save_checkpoint():
	checkpoint_data.position = player.global_transform.origin
	for crate in Groups.get_from(Groups.DESTROYABLE):
		var c:Crate = crate
		if c.destroyed:
			c.add_to_group(str(Groups.SAVED))
	

func load_last_checkpoint():
	player.global_transform.origin = checkpoint_data.position
	for crate in Groups.get_from(Groups.DESTROYABLE):
		if crate.is_in_group(str(Groups.SAVED)): continue
		crate.event_reenable()
	pass


