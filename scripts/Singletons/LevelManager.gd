extends Node

const CRATE = preload("res://models/crate/rm_crate.tscn")

onready var player:Player = get_tree().get_nodes_in_group("Player")[0]

func activate_hided_crates(id:int):
	if id < 0: return
	for crate in get_tree().get_nodes_in_group("C_HIDE"):
		if crate.activator_id == id:
			crate.enable()
		yield(get_tree().create_timer(.5,false),"timeout")

var checkpoint_data = {
	position = Vector3()
}
func save_checkpoint():
	checkpoint_data.position = player.global_transform.origin
	for crate in get_tree().get_nodes_in_group("C_CRATE"):
		var c:Crate = crate
		if c.is_in_group("DESTROYED"): continue
		elif c.destroyable and c.destroyed:
			c.add_to_group("DESTROYED")
			continue
	

func load_last_checkpoint():
	
	
	
	pass


