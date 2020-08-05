extends Node

onready var camera_controller = $Spatial
onready var m_main:Control = $Control/m_main
onready var m_options:Control = $Control/m_options
onready var tween:Tween = $Control/Tween

func toggle_logo_visibility(enable):
	$Control/Logo.visible = enable
	$Control/LogoD.visible = enable
#called by _on_menu_selected_options at VboxController
func event_options_selected():
	var initial_spd = camera_controller.rot_speed
	camera_controller.rot_speed = 0.03
#	m_main.visible = false
	m_main.set_process(false)
	tween.interpolate_property(m_main,"rect_position:x",m_main.rect_position.x,m_main.rect_position.x + 600,.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
	toggle_logo_visibility(false)	
	tween.start()
	yield(get_tree().create_timer(.5,false),"timeout")
	tween.interpolate_property(m_options,"rect_position:x",-1000,m_options.rect_position.x + 1000,1.5,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(1.5,false),"timeout")
	camera_controller.rot_speed = initial_spd
#	m_options.visible = true
	m_options.set_process(true)
	pass

func event_goback_selected():
	var initial_spd = camera_controller.rot_speed
	camera_controller.rot_speed = -0.03
#	m_main.visible = false
	m_options.set_process(false)
	tween.interpolate_property(m_options,"rect_position:x",m_options.rect_position.x,-1000,.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
	toggle_logo_visibility(true)
	
	tween.start()
	
	yield(get_tree().create_timer(.5,false),"timeout")
	tween.interpolate_property(m_main,"rect_position:x",m_main.rect_position.x,m_main.rect_position.x - 600,1.5,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(1.5,false),"timeout")
	camera_controller.rot_speed = initial_spd
#	m_options.visible = true
	m_main.set_process(true)
	pass
