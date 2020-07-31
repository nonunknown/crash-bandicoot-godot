extends Enemy
class_name EnemySpider

export var time_to_bottom:float = 3

onready var initial_pos = global_transform.origin
onready var top_pos = $Top.global_transform.origin

func _ready():
	pass

var tempo = 0
func _process(delta):
	if dead: return
#	print(str(time_to_bottom))
	time_to_bottom -= delta
	if time_to_bottom < 0: time_to_bottom = 3
	if time_to_bottom < 1.5:
		global_transform.origin = lerp(global_transform.origin,top_pos,0.1)
	elif time_to_bottom > 1.5:
		global_transform.origin = lerp(global_transform.origin,initial_pos,0.1)
	
		
	tempo = rand_range(0,100)
	if tempo > 98:
		$sfx.play()



func _on_Area_body_shape_entered(body_id, body, body_shape, area_shape):
	if !body.is_in_group(str(Groups.PLAYER)): return
	if body.global_transform.origin.y > global_transform.origin.y:
		kill()
		body.action_jump(1)
		body.machine.change_state(2)
	else: body.die()
	pass # Replace with function body.
