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

@export var Hitboxes : Array[Area3D]
@export var IsLeftHandWeapon : bool = false
@export var UpgradeLevel : int = 0
@export var InternalName : String = "weapon"
@export var LoreName : String = "Default Weapon"
var Weapon_Path : String = ""

func set_owner_weapon():
	var mypath = self.get_path()
	var myowner = get_node(owner.get_path())
	Weapon_Path = str(mypath)
	#print_debug(owner.owner.name)
	if "Current_Weapon_R" in myowner:
		if IsLeftHandWeapon == true:
			myowner.Current_Weapon_L = get_node(mypath)
			print_debug(str(myowner.name)+" L Weapon: "+str(myowner.Current_Weapon_L))
		else:
			myowner.Current_Weapon_R = get_node(mypath)
			print_debug(str(myowner.name)+" R Weapon: "+str(myowner.Current_Weapon_R))

# Called when the node enters the scene tree for the first time.
func _ready():
	set_owner_weapon()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
