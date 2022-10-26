extends CharacterBody3D
class_name ActorBase

## SYSTEM

@export var Player_Number:int = 0
@export var Actor_Team:int = 0

@export var ActorMeshPath:NodePath
@onready var ActorMesh = get_node(ActorMeshPath)
@onready var ActorAnimationPlayerNode :AnimationPlayer = ActorMesh.get_node("AnimationPlayer")

var ActorHitAreas:Array[Area3D]
var HitByArray:Array[String]

## STATS

@export var Max_HP:int = 100
@export var Custom_Starting_HP:int = -1
var Current_HP:int = 100

@export var Max_Stamina:int = 100
@export var Custom_Starting_Stamina:int = -1
var Current_Stamina = 100
@export var Use_Global_Stamina_Regen_Rate:bool = true
@export var Custom_Stamina_Regen_Rate:int = 4

@export var Natural_Poise:int = 100
var Additional_Poise:int = 0

## ANIMATIONS

#IDLE ANIMATION IS THE FALLBACK, SO WE MAKE SURE
#WE HAVE IT FILLED OUT HERE SO ALL CHILD CLASSES
#CAN REFER BACK TO IT
@export var IdleAnimationName = "HumanoidBase/idle1"
var CurrentAnimationName:String = "none"
var CurrentAttackAnimation :String = ""
var QueuedAttackAnimation : String = ""


## RESPAWN AND SAVE

@export var DoNotRespawn:bool = false
var HasBeenKilled : bool = false
@export var SaveStatus:bool = false


## STATES FOR ALL ACTORS

#WHICH WEAPON TO PING FOR HITBOXES
var PingLeftWeapon : bool = false

#TWO HANDING STATES - 0-1H,1-2HRightWeapon,2-2HLeftWeapon
var Two_Handing_State : int = 0

#CURRENT COMBO LENGTH
var attack_queued : bool = false
var current_combo : int = 0

var locked_on : bool = false
var jumping : bool = false
var taking_damage : bool = false
var attacking : bool = false
var pained : bool = false
var can_be_hit : bool = true
var can_combo : bool = true
var alive : bool = true
var sprinting : bool = false

## PHYSICS

var direction : Vector3
var horizontal_velocity : Vector3
var vertical_velocity : Vector3
@export var starting_speed:int = 5
@onready var current_speed = 0
@onready var sprint_speed:int = int(starting_speed*2)
@export var jump_velocity:int = 4
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var rotation_speed:int = 12
@export var acceleration:int = 5
var rotation_multiplier : float = 1.0
var movement_multiplier : float = 1.0

var rootmotion:float = 0



##REQUIRED NODES


## SIGNALS

signal hurt
signal dead
signal healing
signal outofstamina

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_initial_values()
	
	pass # Replace with function body.

### SETUP FUNCTIONS

func setup_initial_values():
	#load_actor_status()
	
	var saveableactor = Callable(self,"save_actor_status")
	#$GlobalSystemSettings.connect("save_all_actors",saveableactor)
	Current_HP = (Max_HP if Custom_Starting_HP < 1 else Custom_Starting_HP)
	Current_Stamina = (Max_HP if Custom_Starting_Stamina < 1 else Custom_Starting_Stamina)
	create_timer("RootMotionUpdateTimer",0.5,false,true)

func create_timer(timername:String="NewTimer",time:float=2.0,oneshot:bool=false,auto_start:bool=false):
	var timercallable = Callable(self,"_"+str(timername)+"_timeout")
	var newtimer = Timer.new()
	newtimer.name = timername
	newtimer.wait_time = time
	newtimer.one_shot = oneshot
	if self.has_method("_"+str(timername)+"_timeout"):
		newtimer.connect("timeout",timercallable)
		print_debug(str(self.name)+"has _"+str(timername)+"_timeout method, connecting.")
	else:
		print_debug(str(self.name)+"does not have _"+str(timername)+"_timeout method, exiting.")
		return
	self.add_child(newtimer)
	if auto_start == true:
		newtimer.start()

func affect_timer(timername:Timer,setto:bool=true):
	if is_instance_valid(timername):
		if setto == true:
			#print_debug("Started "+str(timername))
			timername.start()
		else:
			#print_debug("Stopped "+str(timername))
			timername.stop()
	else:
		print_debug(str(self.name)+" tried to affect nonexistent timer "+str(timername))

func save_actor_status():
	var savepath = str($GlobalSystemSettings.SaveFilePath)
	var savefile = FileAccess.open(savepath,FileAccess.WRITE)
	if self.SaveStatus == true:
		savefile.store_var(self.Current_HP)
		savefile.store_var(self.Current_Stamina)
		savefile.store_var(self.transform)
	if Player_Number != 0:
		savefile.store_var(self.Two_Handing_State)
	savefile.store_var(self.HasBeenKilled)

func load_actor_status():
	var savepath = str($GlobalSystemSettings.SaveFilePath)
	if FileAccess.file_exists(savepath):
		var savefile = FileAccess.open(savepath,FileAccess.READ)
		if self.SaveStatus == true:
			self.Current_HP = savefile.get_var()
			self.Custom_Starting_HP = self.Current_HP
			self.Current_Stamina = savefile.get_var()
			self.Custom_Starting_Stamina = self.Current_Stamina
			self.transform = savefile.get_var()
		if Player_Number != 0:
			self.Two_Handing_State = savefile.get_var
		self.HasBeenKilled = savefile.get_var()
			

### ALL ACTOR COMBAT FUNCTIONS

func affect_pained_state(setto:bool):
	pained = setto
	if setto == true:
		movement_multiplier = 0.05
	else:
		movement_multiplier = 1.0
		
func allow_combo():
	can_combo = true
	if attack_queued == true:
		if QueuedAttackAnimation =="":
			QueuedAttackAnimation = CurrentAttackAnimation
		CurrentAttackAnimation = QueuedAttackAnimation
		
func stop_attacking():
	attacking = false
	attack_queued = false
	current_combo = 0
	can_combo = true
	rotation_multiplier = 1.0
	
func change_rotation_multiplier(amount:float=1.0,movementamount:float=1.0):
	if rotation_multiplier != amount:
		var current_rotation_multiplier = rotation_multiplier
		rotation_multiplier = lerp(current_rotation_multiplier,amount,1)
	if movement_multiplier != movementamount:
		var current_movement_multiplier = movement_multiplier
		movement_multiplier = lerp(movement_multiplier,movementamount,1)
		#print_debug(str(self.name)+" rotation changed! "+str(rotation_multiplier))

### ALL ACTOR MOVEMENT FUNCTIONS

func handle_actor_gravity(timescale:float):
	if not is_on_floor(): 
		vertical_velocity += Vector3.DOWN * gravity * timescale
	else: 
		vertical_velocity = -get_floor_normal() * gravity / 3

func add_actor_forward_force(horzpower:float=3.0):
	horizontal_velocity = direction*horzpower

func try_actor_jump(additionalheight:int=0,force:bool=false):
	if (is_on_floor() and force==false) or force == true:
		velocity.y = jump_velocity+additionalheight

##TIMEOUTS

func _RootMotionUpdateTimer_timeout():
	var RootbonePosition:Vector3 = ActorMesh.Skeleton.get_bone_pose_position(0)
	var LocalRootmotion:Vector3 = ActorMesh.global_transform.basis.z
	rootmotion = LocalRootmotion.z * RootbonePosition.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	handle_actor_gravity(delta)
