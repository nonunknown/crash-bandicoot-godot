extends Node

signal event_restart
signal event_start_tt
signal event_level_finished
#signal can_start_scene
signal player_died
enum MODE {CRYSTAL,GEM,TIME_TRIAL}
const CRATE = preload("res://model/crate/rm_crate.tscn")

var game_mode:int = MODE.GEM
var player:Player
var UID = null

func player_is_dead()->bool: 
	return player.dead

func get_current_level_name() -> String: return "Dragon's Teeth"

func get_user_name() -> String: return UID

func _ready():
	if get_tree().has_group(str(Groups.PLAYER)):
		player = Groups.get_first(Groups.PLAYER)
	connect("event_start_tt",self,"_on_event_start_tt")
	connect("event_level_finished",self,"_on_level_finished")
	connect("event_restart",self,"_on_event_restart")

onready var stream_pop = load("res://Sounds/crate/pop.wav") as AudioStream
func activate_hided_crates(id:int):
	if id < 0: return
	for crate in Groups.get_from(Groups.HIDE):
		if crate.activator_id == id:
			crate.activator.activate()
			SoundManager.layer_play(SoundManager.bus_enemies,stream_pop,crate.global_transform.origin)
			yield(get_tree().create_timer(.28,false),"timeout")

var checkpoint_data = {
	position = Vector3(),
	first_save = false
}
func save_checkpoint():
	if game_mode == MODE.TIME_TRIAL: return
	if player == null: player = get_tree().get_nodes_in_group(str(Groups.PLAYER))[0]
	checkpoint_data.first_save = true
	checkpoint_data.position = player.global_transform.origin
	for crate in Groups.get_from(Groups.DESTROYABLE):
		var c = crate
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
	for enemy in Groups.get_from(Groups.ENEMIES):
		enemy.event_reenable()
	pass

func _on_event_start_tt():
	game_mode = MODE.TIME_TRIAL
	for crate in Groups.get_from(Groups.CRATES):
		if !crate.timeable: continue
		crate.time_manager.activate_time_behavior()
		yield(get_tree(),"idle_frame")
	pass
	

func _on_level_finished():
	if Groups.get_first(Groups.TIME_TRIAL) == null:
		yield(get_tree().create_timer(3,false),"timeout")
		restart_scene()
	
	print("level finished")
	pass

func restart_scene():
	get_tree().reload_current_scene()
	emit_signal("event_restart")
	
	pass

func _on_event_restart():
	game_mode = MODE.GEM

var is_offline:bool = false
func set_offline(mode:bool=false):
	is_offline = mode
