extends Crate
class_name CrateTNT

func _ready():
	._ready()
	set_process(false)

func event_destroy(player):
	$Area/CollisionShape.disabled = true	
	if player!= null :player.action_jump(1)
	$AnimationPlayer.play("activate")

func event_reenable():
	.event_reenable()
	set_process(false)
	timer = 0.5
	$ExplosionArea/CollisionShape.disabled = true
	$Model.visible = true
#	$AnimationPlayer.seek(0.0,false)
	$AnimationPlayer.stop()
	

var explosion = load("res://Sounds/crate/tnt_explosion.wav") as AudioStream
func event_explode():
	$P_Explosion.emitting = true
	print("oi")
	$sfx.stream = explosion
	$sfx.play()
	$Model.visible = false
	$Area/CollisionShape.disabled = true
	$CollisionShape.disabled = true
	$ExplosionArea/CollisionShape.disabled = false
	set_process(true)

var timer = 0.5

func _process(delta):
	timer -= delta
	if timer < 0:
		$ExplosionArea/CollisionShape.disabled = true
		set_process(false)

func _on_animation_finished(anim_name):
	event_explode()
	


func _on_ExplosionArea_body_entered(body):
	print("found "+body.name)
	if body.is_in_group("Player"):
		body.die()
	if body.is_in_group("C_CRATE"):
		print("test")
		body.event_destroy(null)
	pass # Replace with function body.
