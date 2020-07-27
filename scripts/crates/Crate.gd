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
export var activator_id:int = -1
export var timeable:bool = false
export var time:float = 0
export(Gravity) var gravity_type:int = 0

var animation:AnimationPlayer
var destroyed:bool = false
var particle:Particles
var gravity_manager = null
var hud_gameplay:HUDGameplay
var activator:ActivatorCrateManager = null
var time_manager:TimeCrateManager = null

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
	hud_gameplay = Groups.try_get_first(Groups.HUD_GAMEPLAY)
#	LevelManager.connect("event_start_tt",self,"_on_event_start_tt")

func _enter_tree():
	if activator_id > -1: #initialize a Hided crate
		activator = ActivatorCrateManager.new(activator_id,self)
		print("crate")
	if timeable:
		time_manager = TimeCrateManager.new(self)
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
	if hud_gameplay != null:
		hud_gameplay.update_boxes(1)
	if time_manager != null: time_manager.event_destroy()
	destroyed = true
	if player != null:
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
	if activator_id > -1:
		activator.event_reenable()
	if timeable:
		$Model.restore_textures()
	if !destroyable: return
	if destroyed and hud_gameplay != null:
		hud_gameplay.update_boxes(-1)
	$CollisionShape.disabled = false
#	$ItmPowderBox.visible = true
	destroyed = false
	$Model.visible = true
#	$Area/CollisionShape.disabled = false
	
	pass



#func make_time_trial():
#	print("making time trial")
#	var crate_time = load("res://gameplay/crates/obj_crate_time.tscn").instance()
#	crate_time.configure_time(time)
#	get_parent().add_child(crate_time)
#	crate_time.global_transform.origin = global_transform.origin
#	event_destroy(null)
#
#	pass

#func _on_Area_area_entered(area):
#	print("crate got: "+area.name)
#	pass # Replace with function body.
#
#
#func _on_Area_body_entered(body):
#	print("body: "+body.name)
#	pass # Replace with function body.
