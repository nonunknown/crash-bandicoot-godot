extends VehicleBody

onready var initial_rot = $bike/Front.rotation_degrees.y

func _physics_process(delta):
#	print("test")
	var v_input = int(Input.is_action_pressed("ui_up"))
	var h_input = -int(Input.is_action_pressed("ui_right")) + int(Input.is_action_pressed("ui_left"))
	engine_force = 10000
#	$bike/Front.rotation_degrees.y = initial_rot + (h_input * 35)
#	var is_grounded = $RayCast.is_colliding()
#	if !is_grounded: return
#	var force = $bike/BackWheel_0_0_node.global_transform.basis.x * 5 * v_input
#	add_force(force,$bike/BackWheel_0_0_node.global_transform.origin)

#extends KinematicBody
#
#export var gravity:float = -2000
#export var max_speed = 300
#const JUMP_SPEED = 700
#const ACCELERATION = 2
#const DECELERATION = 4
#const MAX_SLOPE_ANGLE = 40
#const TIME_JUMP = 0.1
#
#
#var cam:Camera
#var velocity:Vector3
#var has_contact:bool = false
#var dir = Vector3()
#var hor_speed:float = 0
#var last_dir:Vector3 = Vector3()
#var input_enabled:bool = true
#onready var front_initial_rot = $bike/Front.rotation_degrees.y
#onready var animation:AnimationPlayer = $bike/crashBiker/AnimationPlayer
#
#onready var _initial_speed = max_speed
#
#onready var menu_pause:HUDPause = load("res://gameplay/HUD/HUD_Pause.tscn").instance()
#
##func _init():
##	add_to_group(str(Groups.PLAYER))
#
## Called when the node enters the scene tree for the first time.
#func _ready():
##	get_tree().root.call_deferred("add_child",menu_pause)
##	$SpinArea.add_to_group(str(Groups.SPIN))
##	LevelManager.save_checkpoint()
#
#	cam = get_viewport().get_camera()
#	pass # Replace with function body.
#
#
#func _physics_process(delta):
#
#	print("test")
#	if input_enabled:
#		dir = Vector3()
#		dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
#		dir.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
#
#		if dir.x > 0:
#			animation.play("turn_right-loop")
#		elif dir.x < 0:
#			animation.play("turn_left-loop")
#		else:
#			animation.play("idle-loop")
#
#		if Input.is_action_just_pressed("cmd_pause"):
#			menu_pause.do_pause()
#
#		last_dir = dir
##	else: dir = last_dir
#
##	var cam_basis = cam.global_transform.basis
##	var basis = cam_basis.rotated(cam_basis.x, -cam_basis.get_euler().x)
##	dir = basis.xform(dir)
#
#	if dir.length_squared() > 1:
#		dir /= dir.length()
#
#
#	if (is_on_floor()):
#		has_contact = true
#		var floor_angle = rad2deg( acos( $RayCast.get_collision_normal().dot(Vector3.UP) ) )
##		print("angle: "+str(floor_angle))
#		if floor_angle > MAX_SLOPE_ANGLE:
#			calc_gravity(delta)
#
#	else: 
#		if !$RayCast.is_colliding():
#			has_contact = false
#		calc_gravity(delta)
#
#	if ( has_contact and !is_on_floor() ):
##		print("test")
##		var n = $Ray.get_collision_normal()
#		move_and_collide(Vector3(0,-1,0))
#
##	velocity.x = dir.x * max_speed
##	velocity.z = dir.z * max_speed
#	$bike/Front.rotation_degrees.y = front_initial_rot + ( -dir.x * 35)
#	var t = dir.z * -$bike/Front.global_transform.basis.z * max_speed
#	velocity.x = t.x
#	velocity.z = t.z
#	rotation_degrees.y = -$bike/Front.global_transform.basis.z.y
##	if has_contact and Input.is_action_pressed("ui_select") and input_enabled and time_to_jump < 0:
##		action_jump()
##	adjust_direction()
#	velocity = move_and_slide(velocity, Vector3.UP)
#	if !input_enabled: velocity = Vector3()
#
#	if is_on_floor():
#		var col_data =move_and_collide(Vector3(0,-1,0))
##		if col_data != null:
##			collision_handler_floor(col_data)
##	elif is_on_ceiling():
##		var cold_data = move_and_collide(Vector3(0,1,0))
##		if cold_data != null:
##			collision_handler_ceilling(cold_data)
#
#
#	hor_speed = abs ( Vector2(velocity.x,velocity.z).length() )
#
##	var xform:Transform = align_with_y(global_transform,$RayCast.get_collision_normal())
##	rotation_degrees.x = xform.basis.get_euler().y
##	transform.basis.z = $RayCast.get_collision_normal() * Vector3(-1,1,-1)
#	pass
#
#func align_with_y(xform:Transform, new_y):
#	xform.basis.y = new_y
#	xform.basis.x = -xform.basis.z.cross(new_y)
#	xform.basis = xform.basis.orthonormalized()
#	return xform
#
#var new_angle:float = 0
#var new_dir:Vector3 = Vector3.ZERO
#func adjust_direction():
#	if (dir != Vector3.ZERO):
#		new_dir = dir
#	var angle:float = atan2(new_dir.x,new_dir.z)
#	new_angle = lerp_angle(new_angle,angle,.4)
#	var deg = rad2deg(new_angle)
#	rotation_degrees.y = deg
#
#func calc_gravity(delta):
#	velocity.y += delta * gravity
#	if velocity.y < 0.0 && velocity.y > -10.0:
#		velocity.y = -10.0
