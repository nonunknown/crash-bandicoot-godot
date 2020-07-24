extends Crate
class_name CrateTNT

var activated:bool = false

func _init():
	._init()
	add_to_group(str(Groups.C_TNT))

func _ready():
	._ready()
	$ExplosionArea.add_to_group(str(Groups.EXPLOSION))
#	set_process(false)

func event_destroy(player):
#	$Area/CollisionShape.disabled = true
	if activated: return
	activated = true
	if player!= null :player.action_jump(1)
	$AnimationPlayer.play("activate")
	destroyed = true

func event_reenable():
	$AnimationPlayer.stop()
	.event_reenable()
	$ExplosionArea/CollisionShape.disabled = true
	$Model.visible = true
	activated = false
	$AnimationPlayer.seek(0,true)
#	$AnimationPlayer.seek(0.0,false)
	

var explosion = load("res://Sounds/crate/tnt_explosion.wav") as AudioStream
func event_explode():
	destroyed = true
	$P_Explosion.fx_emit()
	print("oi")
	$sfx.stream = explosion
	$sfx.play()
	$Model.visible = false
#	$Area/CollisionShape.disabled = true
	$CollisionShape.disabled = true
	$ExplosionArea/CollisionShape.disabled = false
	yield(get_tree().create_timer(0.3,false),"timeout")
	$ExplosionArea/CollisionShape.disabled = true

func _on_animation_finished(_anim_name):
	event_explode()
	


func _on_ExplosionArea_body_entered(body):
	print("found "+body.name)
	if body.is_in_group(str(Groups.PLAYER)):
		body.die()
	if body.is_in_group(str(Groups.CRATES)):
		print("loko")
		body.event_destroy(null)
	pass # Replace with function body.

func _on_Area_entered(area):
	if area.is_in_group(str(Groups.SPIN)):
		event_explode()


#		var c = area.get_parent()
#		if c.gravity_type > 0:
#			event_destroy(null)


func _on_ExplosionArea_area_entered(area):
	print(area.get_parent().name)
	pass # Replace with function body.
