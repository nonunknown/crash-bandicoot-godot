extends StaticBody
class_name Item

export var throwable:bool = true
export var can_respawn:bool = false

var _time_to_destroy:float = 1
var _time_god_mode:float = 3

onready var initial_pos:Vector3 = global_transform.origin
onready var area:Area = $Area

func _init():
	add_to_group(str(Groups.ITEMS))

func _ready():
	set_physics_process(false)
	LevelManager.connect("event_restart",self,"_on_event_restart")

func _enter_tree():
	print("test")
#	if throwable:
#		throwable = false
#		while(_time_god_mode > 0):
#			_time_god_mode -= 0.1
#			yield(get_tree(),"idle_frame")
#		throwable = true

#func _physics_process(delta):
#	global_translate(global_transform.basis.z * delta * 50)
#	_time_to_destroy -= delta
#	if _time_to_destroy < 0:
#		set_physics_process(false)
#		_time_to_destroy = 1
#		_disable()
		

func event_touched(player:Player):
#	_disable()
	pass

func event_spinned(player:Player):
	if !throwable and !can_respawn:
		queue_free()
	elif can_respawn:
		visible = false
		
#	rotation_degrees.y = rand_range(0,360)
#	set_physics_process(true)


func event_reenable():
	if !can_respawn: return
	_enable()
	pass

func _disable():
	$Area/CollisionShape.disabled = true
	visible = false
	if (!can_respawn): _destroy()

func _destroy():
	queue_free()
	
func _enable():
	visible = true
	$Area/CollisionShape.disabled = false
	global_transform.origin = initial_pos

func _on_body_entered(body):
	if body.is_in_group(str(Groups.PLAYER)):
		event_touched(body)
	
	pass # Replace with function body.

func _on_area_entered(area):
	event_spinned(area)
	pass # Replace with function body.

func _on_event_restart():
	queue_free()
	pass
