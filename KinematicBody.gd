extends KinematicBody

func _ready():
	yield(get_tree().create_timer(1,false),"timeout")
	$AreaExplosion/CollisionShape.disabled = false

func _on_AreaExplosion_body_entered(body):
	print("destroy")
	pass # Replace with function body.
