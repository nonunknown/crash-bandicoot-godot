extends Crate
class_name CrateTNT

var activated:bool = false
onready var area_explosion:Area = $ExplosionArea
func _init():
	._init()
	add_to_group(str(Groups.C_TNT))

func _ready():
	._ready()
	$ExplosionArea.add_to_group(str(Groups.EXPLOSION))
	remove_child(area_explosion)
	
#	set_process(false)

func event_destroy(player):
#	$Area/CollisionShape.disabled = true
	if activated: return
	activated = true
	if player!= null :player.action_jump(1)
	$AnimationPlayer.play("activate")

func event_reenable():
	$AnimationPlayer.stop()
	.event_reenable()
	
	$Model.visible = true
	activated = false
	$AnimationPlayer.seek(0,true)
#	$AnimationPlayer.seek(0.0,false)
	

var explosion = load("res://Sounds/crate/tnt_explosion.wav") as AudioStream
func event_explode():
	destroyed = true
	print("explode")
	$AnimationPlayer.stop()
	if hud_gameplay != null:
		hud_gameplay.update_boxes(1)
	destroyed = true
	$P_Explosion.fx_emit()
	print("oi")
	$sfx.stream = explosion
	$sfx.play()
	$Model.visible = false
	$CollisionShape.disabled = true
	add_child(area_explosion)
	$ExplosionArea/CollisionShape.disabled = false
	yield(get_tree().create_timer(.2,false),"timeout")
	remove_child(area_explosion)

func _on_animation_finished(_anim_name):
	event_explode()
	


func _on_ExplosionArea_body_entered(body):
	print("found "+body.name)
	if body.is_in_group(str(Groups.PLAYER)):
		body.die()
	elif body.is_in_group(str(Groups.CRATES)):
		if body.destroyed: return
		if body.is_in_group(str(Groups.C_TNT)) or body.is_in_group(str(Groups.C_NITRO)):
			yield(get_tree().create_timer(0.3,false),"timeout")
			body.event_explode()
			print("FUCKKKK")
			return
		body.event_destroy(null)

#func _on_Area_entered(area):
#	if area.is_in_group(str(Groups.SPIN)):
#		event_explode()
#
#
#func _on_ExplosionArea_area_entered(area):
#	print("haha: "+area.get_parent().name)
#	pass # Replace with function body.
