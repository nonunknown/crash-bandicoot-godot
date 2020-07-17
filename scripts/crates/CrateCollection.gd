extends CrateWumpa
class_name CrateCollection

var life = 5

func event_player_touched(player:Player):
	life -= 1
	if life <= 0:
		event_destroy(player)
		return
	animation.animation_set_next("bounce","idle")
	animation.play("bounce")
	player.action_jump()
	
	
	#TODO: Add wumpa to crash
	pass

func event_reenable():
	.event_reenable()
	life = 5
	animation.play("idle")
