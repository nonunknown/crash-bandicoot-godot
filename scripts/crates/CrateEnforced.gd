extends CrateWumpa
class_name CrateEnforced

func event_player_touched(player:Player):
#	animation.animation_set_next("semi-bounce","idle")
	animation.play("semi-bounce")
	pass

func event_destroy(player:Player):
	animation.play("semi-bounce")
	pass

func event_player_untouched(player):
	animation.play("idle")
