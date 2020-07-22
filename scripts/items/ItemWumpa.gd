extends Item
class_name ItemWumpa

var elapsed:float = 0
export var picked:AudioStream
export var added:AudioStream

func _ready():
	set_process(false)

func event_touched(player):
	SoundManager.layer_play_normal(SoundManager.bus_items,picked)
	$Area/CollisionShape.disabled = true
	print("touched")
	set_process(true)


func _process(delta):
	elapsed += delta
	follow()

func follow():
	var target = LevelManager.player.global_transform.origin + Vector3(0,100,0)
	if elapsed < .5:
		global_transform.origin = lerp(global_transform.origin, global_transform.origin + Vector3.UP *150,0.3)
		return
	
	
	global_transform.origin = lerp(global_transform.origin,Vector3(cos(elapsed) + target.x, ( sin(elapsed) ) + target.y,target.z),0.3)
	if global_transform.origin.distance_squared_to(target) < 1500:
		SoundManager.layer_play_normal(SoundManager.bus_items,added)
		queue_free()
		

