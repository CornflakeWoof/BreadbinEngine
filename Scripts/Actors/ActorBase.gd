extends CharacterBody3D
class_name ActorBase

## SYSTEM

@export var Player_Number:int = 0

##TEAMS - 0-No team,1-Players,2-FriendlyNPCs,3-FriendliesYouCanHit,4-HostileNPCs,5-EnemiesA,6-EnemiesB
@export_enum("Inactive","Players","Friendly NPC No Friendly Fire", "Friendly NPC Friendly Fire", "Hostile NPC", "Enemy Team A", "Enemy Team B") var Actor_Team:int = 0

@export var ActorMeshPath:NodePath
@onready var ActorMesh = get_node(ActorMeshPath)
var ActorMeshOriginalLocation : Vector3 = Vector3.ZERO
@onready var ActorAnimationPlayerNode = ActorMesh.get_node("AnimationPlayer")
@onready var ActorAnimationTreeNode = ActorMesh.get_node("AnimationTree")

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

## RESISTANCES
# BASE DAMAGE ARRAY VALUES - 0)PHYS, 1)MAGIC, 2)FIRE, 3) LIGHTNING, 4)HOLY, 5)DARK
@export var ResistancesBase : Array[float] = [1.0,1.0,1.0,1.0,1.0,1.0]
var CurrentResistances : Array [float] = ResistancesBase

## DAMAGE VALUES

var LastHit_AttackID :int = 100
var LastHit_AttackMultipllier : float = 1.0

## ANIMATIONS

#IDLE ANIMATION IS THE FALLBACK, SO WE MAKE SURE
#WE HAVE IT FILLED OUT HERE SO ALL CHILD CLASSES
#CAN REFER BACK TO IT
@export var IdleAnimationName = "HumanoidBase/idle1"
#DEFAULT FALLBACK DODGE/ROLL MOVE
@export var RollAnimationName = "HumanoidBase/roll"
#FAILSAFE TO CANCEL ROLL AND RETURN TO IDLE
var RollResetTime : float = 1.5
var CurrentAnimationName:String = "none"
var CurrentAttackAnimation :String = ""
var QueuedAttackAnimation : String = ""
var CanChangeAnimation:bool = true

#"idle" FOR MOVEMENT, "attacking" FOR ATTACKS, "rolling" FOR ROLLS
var ActorState : String = "idle"
const ValidActorStates : Array[String] = ["idle","rolling","attacking","dead"]


## RESPAWN AND SAVE

@export var DoNotRespawn:bool = false
var HasBeenKilled : bool = false
@export var SaveStatus:bool = false


## STATES FOR ALL ACTORS

#WHICH WEAPON TO PING FOR HITBOXES
var PingLeftWeapon : bool = false

#TWO HANDING STATES - 0-1H,1-2HRightWeapon,2-2HLeftWeapon
var Two_Handing_State : int = 0

#DETERMINE IF NEXT STATE SHOULD BE ROLLING OR
#ATTACKING - ROLL SHOULD ALWAYS TAKE PRIORITY
var roll_queued : bool = false
var attack_queued : bool = false
var current_combo : int = 0

var locked_on : bool = false
var jumping : bool = false
var pained : bool = false
var rolling : bool = false
var can_be_hit : bool = true
var can_combo : bool = true
var alive : bool = true
var sprinting : bool = false

## PHYSICS

var direction : Vector3
var horizontal_velocity : Vector3
var vertical_velocity : Vector3
@export var starting_speed:int = 3
@onready var current_speed = 0
@onready var sprint_speed:int = int(starting_speed*2.4)
@export var jump_velocity:int = 4
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var rotation_speed:int = 12
@export var acceleration:int = 5
var rotation_multiplier : float = 1.0
var movement_multiplier : float = 1.0


## WEAPON VARIABLES

var L_Weapon = self
var R_Weapon = self
var Current_Weapon = self

##REQUIRED NODES


## SIGNALS

signal currentstatschanged
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
	
	ActorMeshOriginalLocation = ActorMesh.position
	
	self.set_collision_mask_value(4,true)
	
	create_timer("RollResetTimer",RollResetTime,true,false)
	
	if ActorAnimationPlayerNode.playback_default_blend_time == 0:
		ActorAnimationPlayerNode.playback_default_blend_time = 0.1

func create_timer(timername:String="NewTimer",time:float=2.0,oneshot:bool=false,auto_start:bool=false):
	var timercallable = Callable(self,"_"+str(timername)+"_timeout")
	var newtimer = Timer.new()
	self.add_child(newtimer)
	newtimer.name = timername
	newtimer.wait_time = time
	newtimer.one_shot = oneshot
	newtimer.autostart = auto_start
	if self.has_method("_"+str(timername)+"_timeout"):
		newtimer.connect("timeout",timercallable)
		#print_debug(str(self.name)+"has _"+str(timername)+"_timeout method, connecting.")
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

## ALL ACTOR INFORMATION FUNCTIONS

func get_attack_name_from_attacktable(AttackID:int=100):
	var AttackTableNode : Dictionary = get_node("/root/AttackTable").attacktable
	var AttackNameResult:String = ""
	var NewHitboxMultiplier:float = 1.0
	
	AttackNameResult = AttackTableNode[AttackID][0]
	NewHitboxMultiplier = AttackTableNode[AttackID][1]
	if Current_Weapon != self:
		Current_Weapon.SetHitboxDamageMultiplier(true,0,NewHitboxMultiplier)
	
	#print_debug(AttackNameResult)
	return AttackNameResult

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
		attack_queued = false
		
func stop_attacking():
	if attack_queued == true:
		attack_queued = false
	allow_combo()
	current_combo = 0
	change_rotation_multiplier()
	sprinting = false
	handle_actor_state()

func stop_rolling():
	if roll_queued == true:
		roll_queued = false
	handle_actor_state()
	rotation_multiplier = 1.0
	movement_multiplier = 1.0
	
func ActivateWeaponHitbox(time:float=0.4,whichone:int=0):
	if Current_Weapon != self:
		Current_Weapon.AffectHitbox(whichone,true)
		Current_Weapon.get_node("RemoveHitboxTimerNode").start(time)
	
func handle_actor_state(forcestate:String=""):
	if ValidActorStates.has(forcestate):
		ActorState = forcestate
	else:
		match ActorState:
			"rolling":
				if attack_queued == false:
					ActorState = "idle"
				else:
					ActorState = "attacking"
			"attacking":
				if roll_queued == true:
					ActorState = "rolling"
				else:
					ActorState = "idle"
			_:
				if roll_queued == true:
					ActorState = "rolling"
				elif attack_queued == true:
					ActorState = "attacking"
				else:
					ActorState = "idle"

func _ActorHitArea_entered(area:Area3D):
	if area.get_collision_layer_value(5) == true:
		take_damage(10,true,true)
	elif "HitboxDamageMultiplier" in area:
		if "Hitbox_Team" in area:
			var HitboxTeam :int = 999
			var HitboxFriendFoeArray:Array = get_node("/root/GlobalSystemSettings").Teams_CanHurt
			HitboxTeam = area.Hitbox_Team
			if HitboxFriendFoeArray[Actor_Team].has(HitboxTeam):
				pass

func take_damage(amount:int=0,force:bool=false,instakill:bool=false):
	if instakill == true:
		self.Current_HP = -999
	elif force == true:
		self.Current_HP -= amount
		
	
	if Current_HP <= 0:
		emit_signal("dead")
		kill_or_revive_actor()

func shake_actor(times:int=8,magnitude:float=0.5):
	var originalactorposition:Vector3 = ActorMesh.position
	
	for s in times:
		ActorMesh.position.x = randf_range(-magnitude,magnitude)
		ActorMesh.position.y = randf_range(-magnitude,magnitude)
		ActorMesh.position.z = randf_range(-magnitude,magnitude)
		
	ActorMesh.position = originalactorposition
	
func kill_or_revive_actor(revive:bool=false):
	var multiplier_float:float
	
	multiplier_float = 1.0 if revive == true else 0.0
	
	if revive == true:
		Current_HP = Max_HP
	
	alive = revive
	movement_multiplier = multiplier_float
	rotation_multiplier = multiplier_float
	sprinting = false
	can_combo = revive
	
	
## ANIMATION FUNCTIONS


	
func change_rotation_multiplier(amount:float=1.0,movementamount:float=1.0):
	if rotation_multiplier != amount:
		var current_rotation_multiplier = rotation_multiplier
		rotation_multiplier = lerp(current_rotation_multiplier,amount,1)
	if movement_multiplier != movementamount:
		var current_movement_multiplier = movement_multiplier
		movement_multiplier = lerp(current_movement_multiplier,movementamount,1)
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

func _RollResetTimer_timeout():
	if ActorState == "rolling" and roll_queued == false and attack_queued == false:
		handle_actor_state("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.has_method("_custom_process"):
		call("_custom_process",delta)
	pass

func _physics_process(delta):
	#ALLOW ALL CHILD CLASSES TO SHARE THIS PHYSICS PROCESS
	#BY CHECKING FOR A FUNCTION IN THEIR SCRIPT NAMED
	#"_custom_physics_process" AND RUNNING IT IF THEY DO
	if self.has_method("_custom_physics_process"):
		call("_custom_physics_process",delta)
	handle_actor_gravity(delta)
