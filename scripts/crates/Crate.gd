extends StaticBody
class_name Crate

export var _name:String
export var destroyable:bool = true
export var is_animated:bool = false
onready var particle:Particles = $Particles
var animation:AnimationPlayer


func _ready():
	
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
		player.action_jump()
	$CollisionShape.disabled = true
#	$ItmPowderBox.visible = false
	$Area/CollisionShape.disabled = true
	$Particles.emitting = true
	$Sfx.play()
	
	pass

func event_reenable():
	if !destroyable: return
	$CollisionShape.disabled = false
#	$ItmPowderBox.visible = true
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
