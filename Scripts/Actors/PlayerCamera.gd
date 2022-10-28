extends Node3D

## CREDIT TO PEMGUIN005 FOR PRETTY MUCH ALL OF THIS!

@export var PlayerCharacterMesh:NodePath

var camrot_h = 0
var camrot_v = 0
@export var cam_v_max = -75 # -75 recommended
@export var cam_v_min = -55 # -55 recommended
@export var joystick_sensitivity = 20
var h_sensitivity = .01
var v_sensitivity = .01
var rot_speed_multiplier = .15 #reduce this to make the rotation radius larger
var h_acceleration = 10
var v_acceleration = 10
var joyview = Vector2()

var Camera_Player_Number :int = 1
var PlayerCamUp:String = "P"+str(Camera_Player_Number)+"_CamUp"
var PlayerCamDown:String = "P"+str(Camera_Player_Number)+"_CamDown"
var PlayerCamLeft:String = "P"+str(Camera_Player_Number)+"_CamLeft"
var PlayerCamRight:String = "P"+str(Camera_Player_Number)+"_CamRight"


# Called when the node enters the scene tree for the first time.
func _ready():
	Camera_Player_Number = owner.Player_Number
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		$control_stay_delay.start()
		camrot_h += -event.relative.x * h_sensitivity
		camrot_v += event.relative.y * v_sensitivity
		
		
func _joystick_input():
	if (Input.is_action_pressed(PlayerCamUp) ||  Input.is_action_pressed(PlayerCamDown) ||  Input.is_action_pressed(PlayerCamLeft) ||  Input.is_action_pressed(PlayerCamRight)):
		$control_stay_delay.start()
		joyview.x = Input.get_action_strength(PlayerCamLeft) - Input.get_action_strength(PlayerCamRight)
		joyview.y = Input.get_action_strength(PlayerCamUp) - Input.get_action_strength(PlayerCamDown)
		camrot_h += joyview.x * joystick_sensitivity * h_sensitivity
		camrot_v += joyview.y * joystick_sensitivity * v_sensitivity 
		#$h.rotation_degrees.y = lerp($h.rotation_degrees.y, camrot_h, delta * h_acceleration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _physics_process(delta):
	# JoyPad Controls
	_joystick_input()
	
	var mesh_front = get_node(PlayerCharacterMesh).global_transform.basis.z
	var auto_rotate_speed =  (PI - mesh_front.angle_to($h.global_transform.basis.z)) * get_parent().horizontal_velocity.length() * rot_speed_multiplier
	
	if $control_stay_delay.is_stopped():
		#FOLLOW CAMERA
		
		$h.rotation.y = lerp_angle($h.rotation.y, get_node(PlayerCharacterMesh).global_transform.basis.get_euler().y, delta * auto_rotate_speed)
		camrot_h = $h.rotation.y
	else:
		#MOUSE CAMERA
		$h.rotation.y = lerp($h.rotation.y, camrot_h, delta * h_acceleration)
	
	$h/v.rotation.x = lerp($h/v.rotation.x, camrot_v, delta * v_acceleration)
