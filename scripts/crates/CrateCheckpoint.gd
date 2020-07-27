extends Crate
class_name CrateCheckpoint

func event_destroy(player):
	.event_destroy(player)
	if LevelManager.time_trial_mode: return
	LevelManager.save_checkpoint()
