extends Camera

onready var player = get_parent().get_node("Lab_Bike");

func _ready():
	
	pass

func _process(delta):
	var target = player.global_transform.origin
	var pos = player.get_node("Camera").global_transform.origin
	look_at(target, Vector3.UP)
	global_transform.origin = lerp(global_transform.origin,pos, 0.1)
	pass
