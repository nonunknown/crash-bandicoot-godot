extends Spatial
class_name LevelChecker


onready var hud_warp:HUDWarp = Groups.get_first(Groups.HUD_WARP)

func _on_body_entered(body):
	print("player entered")
	pass # Replace with function body.


func _on_Area_body_exited(body):
	print("player exited")
	pass # Replace with function body.
