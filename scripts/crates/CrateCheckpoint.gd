extends Crate
class_name CrateCheckpoint

func event_destroy(player):
	.event_destroy(player)
	LevelManager.save_checkpoint()
