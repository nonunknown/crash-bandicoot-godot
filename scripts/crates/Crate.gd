extends KinematicBody
class_name Crate

#signal ev_destroy

#Gravity enum
# None - Represents no gravity affected by sorrounding events
# Infinite - Always will be affected by sorrounding events
# Crates - Will only fall 1-N crates down and then will be set to None
# Bouncy - Will bounce if theres a bounce crate bellow
enum Gravity {None,Infinite,Crates,Bounce}

export var destroyable:bool = true
export var is_animated:bool = false
export(Gravity) var gravity_type:int = 0

var animation:AnimationPlayer
var destroyed:bool = false
var particle:Particles
var gravity_manager = null

onready var stream_destroy:AudioStream = load("res://Sounds/crate/crate_break.wav") as AudioStream

func _init():
	add_to_group(str(Groups.CRATES))
	if destroyable: add_to_group(str(Groups.DESTROYABLE))
	

func _ready():
	if has_node("Particles"): particle = $Particles
	set_process(false)
	set_physics_process(false)
	if gravity_type > 0: 
		print("checked type")
		gravity_manager = GravityCrateManager.new(self)
		set_physics_process(true)
#	connect("ev_destroy",self,"_on_ev_destroy")
	pass

func _physics_process(delta):
	gravity_manager._update_physics(delta)

func set_animation(anim:AnimationPlayer):
	animation = anim

func _implement(func_name:String):
	print("IMPLEMENT '%s' in: %s" % [func_name, name])


# == EVENTS == #
func event_player_touched(player):
	event_destroy(player)
	pass

func event_player_untouched(_body):
	pass


func event_destroy(player):
	if is_animated: animation.play("Smash")
	if !destroyable: return
	destroyed = true
	if player.global_transform.origin.y > global_transform.origin.y and !player.is_spinning:
		player.machine.change_state(2) #force restart jump state
		player.action_jump(1) # 1 means jump higher
	$CollisionShape.disabled = true
#	$ItmPowderBox.visible = false
	$Model.visible = false
#	$Area/CollisionShape.disabled = true
	$Particles.emitting = true
	SoundManager.layer_play(SoundManager.bus_crates, stream_destroy, global_transform.origin)
	
	pass

onready var initial_pos = global_transform.origin

func event_reenable():
	global_transform.origin = initial_pos
	if !destroyable: return
	$CollisionShape.disabled = false
#	$ItmPowderBox.visible = true
	destroyed = false
	$Model.visible = true
#	$Area/CollisionShape.disabled = false
	pass

# == LOCAL == #
#func _on_body_entered(body):
#	if body.is_in_group(str(Groups.PLAYER)):
#		event_player_touched(body)
#		return
#
#
#func _on_Area_entered(area):
#	if area.is_in_group(str(Groups.SPIN)) or area.is_in_group(str(Groups.EXPLOSION)) :
#		print(area.name)
#		event_destroy(area.get_parent())
#
##		emit_signal("ev_destroy")
#	pass # Replace with function body.
#
#
#func _on_body_exited(body):
#	if body.is_in_group(str(Groups.PLAYER)):
#		event_player_untouched(body)
#	pass # Replace with function body.


func _on_Area_area_entered(area):
	print("crate got: "+area.name)
	pass # Replace with function body.
