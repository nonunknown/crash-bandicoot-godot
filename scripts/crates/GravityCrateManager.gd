extends Node
class_name GravityCrateManager

enum Gravity {None,Infinite,Crates,Bounce}
var type:int = 0
var crate:KinematicBody = null
var ray:RayCast = null
var gravity = -500
var motion:Vector3 = Vector3()
var col: KinematicCollision
func _init(_crate):
	crate = _crate
	type = crate.gravity_type
#	crate.set_physics_process(true)
	create_raycast()

func create_raycast():
	print("created raycast")
	ray = load("res://resources/crate/RayCrate.tscn").instance()
	crate.call_deferred("add_child",ray)
	crate.global_transform.origin.y += 1
	pass


var t= false
func _update_physics(delta):
	if ray.is_colliding(): 
		motion.y = 0
		if !t:
			var c = ray.get_collider()
			if c.is_in_group(str(Groups.C_TNT)):
				c.event_destroy(null)
			t = true
		
		return
	t = false
	col = crate.move_and_collide(motion * delta + Vector3(0,gravity * delta * delta,0))
	motion.y += gravity * delta
	if motion.y > -10 && motion.y < 0: motion.y = -10
	
#	if !ray.is_colliding():
#		crate.sleeping = false
#	elif crate.sleeping == false: crate.sleeping = true
