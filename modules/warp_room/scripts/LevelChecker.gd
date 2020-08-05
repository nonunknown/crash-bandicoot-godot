extends Spatial
class_name LevelChecker


onready var hud_warp:HUDWarp = Groups.get_first(Groups.HUD_WARP)
export var level_data:Resource
func _on_body_entered(body):
	hud_warp.set_data(level_data)
	hud_warp.show()
	pass # Replace with function body.


func _on_Area_body_exited(body):
	hud_warp.hide()
	pass # Replace with function body.
