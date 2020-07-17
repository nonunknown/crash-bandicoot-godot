extends Crate
class_name CrateItem

func on_crate_destroy():
	
	pass

func event_destroy(player:Player):
	.event_destroy(player)
	on_crate_destroy()
