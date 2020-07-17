extends Player
class_name PlayerState

enum STATE {IDLE,WALK,JUMP,SPIN,DASH,DASH_WALK}
#enum IDLE {IDLE_NORMAL,IDLE_EXTRA}
#enum ID {IDLE}

var machine:NativeStateMachine = NativeStateMachine.new()
#var m_idle:StateMachine = StateMachine.new(self)
var _delta:float

onready var p_smoke:Particles = $P_Smoke
onready var audio:CrashAudio = $SmartAudioStream
onready var spin_area:Area = $SpinArea
onready var animation:AnimationPlayer = $crash/AnimationPlayer

func _ready():
	enable_spin_area(false)
#	machine.register_state_array(STATE.values(), STATE.keys())
#	machine.start()
	machine.register_state(self,STATE.keys())
	
#	m_idle.register_parent(machine, ID.IDLE)
#	m_idle.register_state_array(IDLE.values(), IDLE.keys())
#	m_idle.start()
	pass

func _physics_process(delta):
	_update_physics(delta)
	_delta = delta
	machine.update()
	
	if Input.is_action_pressed("cmd_time"):
		Engine.time_scale = 0.1
	else: Engine.time_scale = 1
	
	ScreenDebugger.dict["STATE"] = STATE.keys()[machine.get_current_state()]
#	ScreenDebugger.dict["Machine_Idle"] = IDLE.keys()[m_idle.get_current_state()]
	ScreenDebugger.dict["Y VEL"] = velocity.y
#	ScreenDebugger.dict["idle_time"] = idle_time
#	ScreenDebugger.dict["hor_speed"] = hor_speed
#	ScreenDebugger.dict["contact"] = has_contact
#	ScreenDebugger.dict["on_floor"] = is_on_floor()
#	ScreenDebugger.dict["FPS"] = Engine.get_frames_per_second()
#	ScreenDebugger.dict["INPUT ENABLED"] = input_enabled


func animation_almost_finished():
	return animation.current_animation_position >= animation.current_animation_length - .05

func emit_little_smoke():
	p_smoke.emitting = true
	yield(get_tree().create_timer(.1,false),"timeout")
	p_smoke.emitting = false

func enable_spin_area(enable:bool):
	spin_area.monitoring = enable
	spin_area.monitorable = enable

## ========== CONDITIONS ==========  ##

func cd_walk():
	if (has_contact && hor_speed > 1):
		machine.change_state(STATE.WALK)

func cd_idle():
	if (has_contact && hor_speed <= .5):
		machine.change_state(STATE.IDLE)

func cd_jump():
	if abs(velocity.y) > 2 && !has_contact:
		machine.change_state(STATE.JUMP)

func cd_spin():
	if Input.is_action_just_pressed("cmd_spin") && !machine.state_is(STATE.SPIN):
		machine.change_state(STATE.SPIN)

func cd_dash():
	if Input.is_action_just_pressed("cmd_dash"):
		machine.change_state(STATE.DASH)

## ========== MAIN STATE MACHINE ========== ##

func st_init_IDLE():
	idle_time = 5
#	m_idle.change_state(IDLE.IDLE_NORMAL)
	animation.play("Idle1")
	
	pass

var idle_time:float = 5
func st_update_IDLE():
#	m_idle.machine_update()
	idle_time -= _delta
	cd_walk()
	cd_jump()
	cd_spin()
	cd_dash()

func st_exit_IDLE():
#	m_idle.call_exit()
	pass

func st_init_WALK():
	if machine.last_state_was(STATE.JUMP):
		emit_little_smoke()
		audio.emit_step()
	$crash/AnimationPlayer.play("Run")
	pass

func st_update_WALK():
	cd_idle()
	cd_jump()
	cd_spin()
	cd_dash()
	pass
	
func st_exit_WALK():
	
	pass

func st_init_JUMP():
	audio.emit_jump()
	if hor_speed < 2 or machine.last_state_was(STATE.SPIN):
		animation.play("Jump")
#	else:
#		animation.play("FrontFlip")
	pass
	

func st_update_JUMP():
	if hor_speed > 2 && velocity.y > 0:
		animation.play("FrontFlip")
	cd_walk()
	cd_idle()
	cd_spin()
	pass

func st_exit_JUMP():
	pass

func st_init_SPIN():
	enable_spin_area(true)
	audio.emit_spin()
	$crash/CrashSpin.visible = true
	$crash/CrashArmature001.visible = false
	animation.play("CrashSpin1")
	is_spinning = true #make crash rotate in adjust_direction()
	pass

func st_update_SPIN():
	if animation_almost_finished():
		cd_idle()
		cd_walk()
		cd_jump()
	pass

func st_exit_SPIN():
	enable_spin_area(false)
	$crash/CrashSpin.visible = false
	$crash/CrashArmature001.visible = true
	is_spinning = false
	pass

var slide:bool = false
func st_init_DASH():
	rotate_shape(true)
	if hor_speed > 1:
		audio.emit_dash()
		input_enabled = false
		p_smoke.emitting = true
		animation.play("Slide")
		slide = true
	else:
		animation.play("CrouchDown")
		slide = false
	
	
	pass

func st_update_DASH():
	var pressed = Input.is_action_pressed("cmd_dash")
	if slide: 
		max_speed = 10
	if slide && animation_almost_finished():
		input_enabled = true
		if hor_speed < 1:
			animation.play("CrouchDown")
			
		else: machine.change_state(STATE.DASH_WALK)
		pass
	if !slide:
		if Input.is_action_just_released("cmd_dash"):
			cd_idle()
			cd_walk()
		elif hor_speed > 1:
			machine.change_state(STATE.DASH_WALK)
#	if !pressed:
#		cd_idle()
#	elif hor_speed > 1:
#		machine.change_state(STATE.DASH_WALK)
#	if animation_almost_finished() && Input.is_action_pressed("cmd_spin") && hor_speed > 1:
#		machine.change_state(STATE.DASH_WALK)
#		return
#	elif !Input.is_action_pressed("cmd_spin"):
#		cd_idle()
#		cd_walk()
#
	pass

func st_exit_DASH():
	input_enabled = true
	slide = false
	max_speed = _initial_speed
	rotate_shape(false)
	p_smoke.emitting = false
	pass

func st_init_DASH_WALK():
	animation.play("Crowl")
	max_speed = 2
	rotate_shape(true)
	pass

func st_update_DASH_WALK():
	var pressing:bool = Input.is_action_pressed("cmd_dash")
	if !pressing:
		cd_walk()
		cd_idle()
	elif pressing && hor_speed < 1:
		machine.change_state(STATE.DASH)
	pass

func st_exit_DASH_WALK():
	max_speed = _initial_speed
	rotate_shape(false)
	pass

## ====== IDLE MACHINE ========== ##

func st_init_IDLE_NORMAL():
	if machine.last_state_was(STATE.JUMP):
		animation.animation_set_next("Land","Idle1")
		audio.emit_step()
		animation.play("Land")
		emit_little_smoke()
	else:
		animation.play("Idle1")
		
	idle_time = 5
	pass

func st_update_IDLE_NORMAL():
	
#	if idle_time < 0:
#		m_idle.change_state(IDLE.IDLE_EXTRA)
		
	
	pass

func st_exit_IDLE_NORMAL():
	print("normal exit")
	pass

func st_init_IDLE_EXTRA():
	$crash/AnimationPlayer.play("Idle2")
	idle_time = 10
	pass

func st_update_IDLE_EXTRA():
#	if idle_time <0:
#		m_idle.change_state(IDLE.IDLE_NORMAL)
	
	pass

func st_exit_IDLE_EXTRA():
	print("extra exit")
	pass


func _on_BodyArea_area_entered(area):
	die()
	pass # Replace with function body.
