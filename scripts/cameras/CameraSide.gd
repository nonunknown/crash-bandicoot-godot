extends Camera


onready var target:Spatial = get_tree().get_nodes_in_group("Player")[0]

func _process(delta):
	var target_pos = target.global_transform.origin
#	look_at(target_pos,Vector3.UP)
	var pos = global_transform.origin
	global_transform.origin = lerp(pos,Vector3(pos.x,target_pos.y+70,target_pos.z),0.5)
	
