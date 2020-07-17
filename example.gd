extends Node

var machine:NativeStateMachine = NativeStateMachine.new();
enum STATE {IDLE,MOVE}


func _ready():
	machine.register_state(self, STATE.keys()) # state keys return ["IDLE","MOVE"]

func _process(delta):
	machine.update()

func st_init_IDLE():
	print("I'm idle")

func st_update_IDLE():
	if Input.is_action_just_pressed("ui_down"):
		machine.change_state(STATE.MOVE)

func st_exit_IDLE():
	print("out of idle")

func st_init_MOVE():
	print("i'm moving")

func st_update_MOVE():
	if Input.is_action_just_pressed("ui_up"):
		machine.change_state(STATE.IDLE)

func st_exit_MOVE():
	print("out of MOVE")


	
	
