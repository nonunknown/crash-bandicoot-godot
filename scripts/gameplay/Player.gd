extends KinematicBody
class_name Player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var gravity:float = -2000
export var max_speed = 300
const JUMP_SPEED = 700
const ACCELERATION = 2
const DECELERATION = 4
const MAX_SLOPE_ANGLE = 40
const TIME_JUMP = 0.1


var cam:Camera
var velocity:Vector3
var has_contact:bool = false
var dir = Vector3()
var hor_speed:float = 0
var is_spinning:bool = false
var last_dir:Vector3 = Vector3()
var input_enabled:bool = true
var time_to_jump = TIME_JUMP
onready var _initial_speed = max_speed



# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_viewport().get_camera()
	pass # Replace with function body.


func _update_physics(delta):
	
	
	if input_enabled:
		dir = Vector3()
		dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		dir.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		last_dir = dir
	else: dir = last_dir
	
	var cam_basis = cam.global_transform.basis
	var basis = cam_basis.rotated(cam_basis.x, -cam_basis.get_euler().x)
	dir = basis.xform(dir)
	
	if dir.length_squared() > 1:
		dir /= dir.length()
		
	
	if (is_on_floor()):
		has_contact = true
		time_to_jump -= delta
		var floor_angle = rad2deg( acos( $Ray.get_collision_normal().dot(Vector3.UP) ) )
#		print("angle: "+str(floor_angle))
		if floor_angle > MAX_SLOPE_ANGLE:
			calc_gravity(delta)
			
	else: 
		if !$Ray.is_colliding():
			has_contact = false
		calc_gravity(delta)
	
	if ( has_contact and !is_on_floor() ):
#		print("test")
		var n = $Ray.get_collision_normal()
		move_and_collide(Vector3(0,-1,0))
	
	velocity.x = dir.x * max_speed
	velocity.z = dir.z * max_speed
	
	if has_contact and Input.is_action_pressed("ui_select") and input_enabled and time_to_jump < 0:
		action_jump()
	adjust_direction()
	velocity = move_and_slide(velocity, Vector3.UP)
	hor_speed = abs ( Vector2(velocity.x,velocity.z).length() )
	
	pass

func action_jump():
	time_to_jump = TIME_JUMP
	velocity.y = JUMP_SPEED
	has_contact = false

var new_angle:float = 0
var new_dir:Vector3 = Vector3.ZERO
func adjust_direction():
	if is_spinning: 
		rotate_y(20)
		return
	if (dir != Vector3.ZERO):
		new_dir = dir
	var angle:float = atan2(new_dir.x,new_dir.z)
	new_angle = lerp_angle(new_angle,angle,.4)
	var deg = rad2deg(new_angle)
	rotation_degrees.y = deg


func rotate_shape(bit:bool):
	if bit:
		#.345
		$CollisionShape.rotation_degrees.x = 0
		$CollisionShape.translation = Vector3(0,0.245,0)
#		$CollisionShape.translate(Vector3(0,.345,0))
	else:
		$CollisionShape.rotation_degrees.x = -90
		$CollisionShape.translation = Vector3(0,0.596,0)
		
#		$CollisionShape.translate(Vector3(0,-.345,0))

onready var initial_pos = global_transform.origin
func die():
	global_transform.origin = initial_pos

func calc_gravity(delta):
	velocity.y += delta * gravity
	if velocity.y < 0.0 && velocity.y > -10.0:
		velocity.y = -10.0
