extends Node
class_name WeaponBase

@export var Weapon_1H_R1 : Array[int] = [100,101,102]
@export var Weapon_1H_R2 : Array[int] = [100]
@export var Weapon_1H_L1 : Array[int] = [100]
@export var Weapon_1H_L2 : Array[int] = [100]
@export var Weapon_1H_RunningAttack : Array[int] = [100]
@export var Weapon_1H_FallingAttack : Array[int] = [100]
@export var Weapon_1H_R1_Critical : Array[int] = [100]
@export var Weapon_1H_L1_Critical : Array[int] = [100]

@export var Weapon_2H_R1 : Array[int] = [100]
@export var Weapon_2H_R2 : Array[int] = [100]
@export var Weapon_2H_L1 : Array[int] = [100]
@export var Weapon_2H_L2 : Array[int] = [100]
@export var Weapon_2H_RunningAttack : Array[int] = [100]
@export var Weapon_2H_FallingAttack : Array[int] = [100]
@export var Weapon_2H_R1_Critical : Array[int] = [100]
@export var Weapon_2H_L1_Critical : Array[int] = [100]

@export var WeaponAudioPlayer:AudioStreamPlayer3D
@export var WhooshSoundPaths:Array[String]
@export var HitSoundPaths:Array[String]

## DAMAGE VARIABLES
# BASE DAMAGE ARRAY VALUES - 0)PHYS, 1)MAGIC, 2)FIRE, 3) LIGHTNING, 4)HOLY, 5)DARK
@export var BaseDamage:Array[int]=[20,0,0,0,0,0]
@onready var CurrentDamage:Array[int]=BaseDamage

#
@export var Hitbox0 : Area3D
@export var Hitbox1 : Area3D
@export var Hitbox2 : Area3D
@export var Hitbox3 : Area3D
@export var Hitbox4 : Area3D
@export var Hitbox5 : Area3D
var Hitboxes : Array[Area3D] = [Hitbox0]
@export var IsLeftHandWeapon : bool = false
@export var UpgradeLevel : int = 0
@export var InternalName : String = "weapon"
var Weapon_Path : String = ""

## WEAPON SIGNALS

signal upgraded

func set_owner_weapon():
	var myowner = owner.owner
	Weapon_Path = self.get_path()
	#print_debug(owner.owner.name)
	if "R_Weapon" in myowner:
		if IsLeftHandWeapon == true:
			myowner.L_Weapon = get_node(Weapon_Path)
			print_debug(str(myowner.name)+" L Weapon: "+str(myowner.L_Weapon))
		else:
			myowner.R_Weapon = get_node(Weapon_Path)
			print_debug(str(myowner.name)+" R Weapon: "+str(myowner.R_Weapon))

func PlayWeaponSound(hitiftrue:bool=true):
	var SoundToPlay = ""
	var RandomResult :int = 0
	var ArrayMax :int = 0
	
	if hitiftrue == true:
		RandomResult = randi_range(0,HitSoundPaths.size()-1)
	else:
		RandomResult = randi_range(0,WhooshSoundPaths.size()-1)

func SetHitboxDamageMultiplier(AllHitboxes:bool=true,WhichHitboxInt:int=0,NewValue:float=1.0):
	var HitboxDamagePerLevel : float = 0.1
	var HitboxLevel : int = 0
	var HitboxToAffect : int = 0
	
	HitboxLevel = Hitboxes[0].HitboxLevel
	
	if AllHitboxes == false:
		if WhichHitboxInt <= Hitboxes.size()-1:
			HitboxToAffect = WhichHitboxInt
		else:
			HitboxToAffect = 0
		
		HitboxDamagePerLevel == Hitboxes[HitboxToAffect].MultiplierPerLevel
		HitboxLevel = Hitboxes[HitboxToAffect].HitboxLevel
		
		Hitboxes[HitboxToAffect].CurrentHitboxDamageMultiplier = NewValue + (HitboxLevel * HitboxDamagePerLevel)
	else:
		for h in Hitboxes.size():
			var HitboxQueried:Area3D = Hitboxes[h]
			HitboxDamagePerLevel = HitboxQueried.MultiplierPerLevel
			HitboxQueried.HitboxDamageMultiplier = NewValue + (HitboxLevel * HitboxDamagePerLevel)

func RegisterHitboxes():
	Hitboxes = [Hitbox0]
	
	var HitboxNumber = 4
	for h in HitboxNumber:
		var HitboxName :String = "Hitbox"+str(h+1)
		if is_instance_valid(HitboxName):
			Hitboxes.append(HitboxName)
	

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	var hitboxtimeout = Callable(self,"AffectHitbox")
	var removehitboxtimer = Timer.new()
	self.add_child(removehitboxtimer)
	removehitboxtimer.one_shot = true
	removehitboxtimer.name = "RemoveHitboxTimerNode"
	removehitboxtimer.wait_time = 0.4
	removehitboxtimer.autostart = false
	removehitboxtimer.connect("timeout",hitboxtimeout,1)
	
	RegisterHitboxes()

func _ready():
	set_owner_weapon()
	pass # Replace with function body.

func AffectHitbox(WhichOne:int=0,setto:bool=false):
	var AffectedHitbox :int = 0
	if WhichOne <= Hitboxes.size()-1:
		AffectedHitbox = WhichOne
	else:
		AffectedHitbox = 0
		
	if setto == false:
		for h in Hitboxes:
			Hitboxes[AffectedHitbox].visible = setto
			Hitboxes[AffectedHitbox].monitorable = setto
			Hitboxes[AffectedHitbox].monitoring = setto
	else:
		Hitboxes[AffectedHitbox].visible = setto
		Hitboxes[AffectedHitbox].monitorable = setto
		Hitboxes[AffectedHitbox].monitoring = setto

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
