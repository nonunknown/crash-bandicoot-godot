extends KinematicBody
class_name Enemy

var dead:bool = false
onready var initial_scale = scale
onready var initial_rot = rotation_degrees
func _ready():
	add_to_group(str(Groups.ENEMIES))

func event_reenable():
	print("ressurecting: "+name)
	
	if !dead: return
	dead = false
	set_process(true)
	$Area/CollisionShape2.disabled = false
	scale = initial_scale
	rotation_degrees = initial_rot
	rot = 0
	pass

func kill():
	if dead: return
	$Area/CollisionShape2.disabled = true
	dead = true
	pass
	
var rot = 0
func _process(delta):
	if !dead: return
	scale = lerp(scale,Vector3(),0.2)
	rot += 0.3
	rotate_y(rot)
	if is_equal_approx(scale.x,0):
		set_process(false)
	pass
