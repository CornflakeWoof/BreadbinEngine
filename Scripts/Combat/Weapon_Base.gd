extends Node
class_name WeaponBase

@export var Weapon_1H_R1 : Array[String] = [""]
@export var Weapon_1H_R2 : Array[String] = [""]
@export var Weapon_1H_L1 : Array[String] = [""]
@export var Weapon_1H_L2 : Array[String] = [""]
@export var Weapon_2H_R1 : Array[String] = [""]
@export var Weapon_2H_R2 : Array[String] = [""]
@export var Weapon_2H_L1 : Array[String] = [""]
@export var Weapon_2H_L2 : Array[String] = [""]
@export var Weapon_1H_RunningAttack : String = ""
@export var Weapon_2H_RunningAttack : String = ""
@export var Weapon_1H_FallingAttack : String = ""
@export var Weapon_2H_FallingAttack : String = ""
@export var Weapon_1H_R1_Critical : String = ""
@export var Weapon_1H_L1_Critical : String = ""
@export var Weapon_2H_R1_Critical : String = ""
@export var Weapon_2H_L1_Critical : String = ""

@export var WeaponAudioPlayer:AudioStreamPlayer3D
@export var WhooshSoundPaths:Array[String]
@export var HitSoundPaths:Array[String]

## DAMAGE VARIABLES
# BASE DAMAGE ARRAY VALUES - 0)PHYS, 1)MAGIC, 2)FIRE, 3) LIGHTNING, 4)HOLY, 5)DARK
@export var BaseDamage:Array[int]=[20,0,0,0,0,0]
@onready var CurrentDamage:Array[int]=BaseDamage

@export var Hitbox : Area3D
@export var IsLeftHandWeapon : bool = false
@export var UpgradeLevel : int = 0
@export var InternalName : String = "weapon"
@export var LoreName : String = "Default Weapon"
var Weapon_Path : String = ""

func set_owner_weapon():
	var myowner = get_node(owner.get_path())
	Weapon_Path = self.get_path()
	#print_debug(owner.owner.name)
	if "Current_Weapon_R" in myowner:
		if IsLeftHandWeapon == true:
			myowner.Current_Weapon_L = get_node(Weapon_Path)
			print_debug(str(myowner.name)+" L Weapon: "+str(myowner.Current_Weapon_L))
		else:
			myowner.Current_Weapon_R = get_node(Weapon_Path)
			print_debug(str(myowner.name)+" R Weapon: "+str(myowner.Current_Weapon_R))

func PlayWeaponSound(hitiftrue:bool=true):
	var SoundToPlay = ""
	var RandomResult :int = 0
	var ArrayMax :int = 0
	
	if hitiftrue == true:
		RandomResult = randi_range(0,HitSoundPaths.size()-1)
	else:
		RandomResult = randi_range(0,WhooshSoundPaths.size()-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_owner_weapon()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
