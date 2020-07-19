extends StaticBody
class_name Crate


#Gravity enum
# None - Represents no gravity affected by sorrounding events
# Infinite - Always will be affected by sorrounding events
# Crates - Will only fall 1-N crates down and then will be set to None
# Bouncy - Will bounce if theres a bounce crate bellow
enum Gravity {None,Infinite,Crates,Bounce}

export var destroyable:bool = true
export var is_animated:bool = false
export(Gravity) var gravity_type = Gravity.None
var animation:AnimationPlayer
var destroyed:bool = false
onready var stream_destroy:AudioStream = load("res://Sounds/crate/crate_break.wav") as AudioStream
var particle:Particles

func _ready():
	if has_node("Particles"): particle = $Particles
	pass

func set_animation(anim:AnimationPlayer):
	animation = anim

func _implement(func_name:String):
	print("IMPLEMENT '%s' in: %s" % [func_name, name])

# == EVENTS == #
func event_player_touched(player:Player):
	event_destroy(player)
	pass

func event_player_untouched(body):
	pass


func event_destroy(player:Player):
	if is_animated: animation.play("Smash")
	if !destroyable: return
	if player.global_transform.origin.y > global_transform.origin.y and !player.is_spinning:
		player.machine.change_state(2) #force restart jump state
		player.action_jump(1) # 1 means jump higher
	$CollisionShape.disabled = true
#	$ItmPowderBox.visible = false
	$Model.visible = false
	$Area/CollisionShape.disabled = true
	$Particles.emitting = true
	SoundManager.layer_play(SoundManager.bus_crates, stream_destroy, global_transform.origin)
	
	pass

func event_reenable():
	if !destroyable: return
	$CollisionShape.disabled = false
#	$ItmPowderBox.visible = true
	$Model.visible = true
	$Area/CollisionShape.disabled = false
	pass

# == LOCAL == #
func _on_body_entered(body):
	if body.is_in_group("Player"):
		event_player_touched(body)


func _on_Area_entered(area):
	if area.is_in_group("Spin"):
		event_destroy(area.get_parent())
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("Player"):
		event_player_untouched(body)
	pass # Replace with function body.
