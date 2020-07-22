extends Crate
class_name CrateIronBounce

export var stream:AudioStream
func event_player_touched(body:Player):
	SoundManager.layer_play(SoundManager.bus_crates,stream,global_transform.origin)
	.event_player_touched(body)
	body.action_jump(1,500,200)
