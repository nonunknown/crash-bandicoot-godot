extends Item
class_name ItemClock

var hud:HUDTimeTrial


func event_touched(player):
	if hud != null: return
	hud = load("res://gameplay/HUD/HUD_TimeTrial.tscn").instance()
	get_tree().root.call_deferred("add_child",hud)
	_disable()
	LevelManager.emit_signal("event_start_tt")
	pass
	
func _on_event_restart():
	if hud != null: 
		hud.queue_free()
		hud = null
	_enable()
#	pass
