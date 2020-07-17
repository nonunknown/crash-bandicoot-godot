extends CrateWumpa
class_name CrateBounce

func event_player_touched(player:Player):
#	.event_player_touched(player)
	animation.animation_set_next("bounce","idle")
	animation.play("bounce")
	player.action_jump()
	pass
