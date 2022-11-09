extends ActorBase
class_name AIActor

## AI SPECIFIC STATS:
@export_enum("Wildlife","Private","Corporal","Sergeant","Lieutenant","Captain","Colonel") var NPC_Tier : int

## KEY NODES

@export var VisionArea:Area3D
var TargetNode = self

## AI PREFERENCES

@export var AttackChanceLight:int = 70
var RealAttackChanceLight :float = 0.2
@export var AttackChanceMid:int = 60
var RealAttackChanceMid : float = 0.2
@export var AttackChanceHeavy:int = 50
var RealAttackChanceHeavy : float = 0.2 

## ATTACK NAME ARRAYS

@export var LightAttackIDs:Array[int]
var LightAttackNumber:int = 0
@export var MidAttackIDs:Array[int]
var MidAttackNumber:int = 0
@export var HeavyAttackIDs:Array[String]
var HeavyAttackNumber:int = 0

func _ready():
	InitializeAIActor()

func InitializeAIActor():
	UpdateAttackNumbers()
	CalculateAttackChances()
	process_priority = (50+NPC_Tier)

# ATTACK ARRAY FUNCTIONS
func UpdateAttackNumbers():
	LightAttackNumber = LightAttackIDs.size()
	MidAttackNumber = MidAttackIDs.size()
	HeavyAttackNumber = HeavyAttackIDs.size()

func CalculateAttackChances():
	var FinalAttackSum :int
	FinalAttackSum = AttackChanceLight+AttackChanceMid+AttackChanceHeavy
	RealAttackChanceLight = AttackChanceLight/FinalAttackSum
	RealAttackChanceMid = AttackChanceMid/FinalAttackSum
	RealAttackChanceHeavy = AttackChanceHeavy/FinalAttackSum
	
	print_debug(str(self.name)+"'s Attack Chances: "+str(round(RealAttackChanceLight*100))+" Light, "+str(round(RealAttackChanceMid*100))+" Mid, "+str(round(RealAttackChanceHeavy*100))+" Heavy")
	
# COMBAT AI FUNCTIONS

func ChooseNextAttackTier():
	var AttackChoiceResult:float = randf_range(0,1.05)
	var AttackArrayString:String
	var AttackArrayPrefix:String
	var HeavyAttackChance : float = RealAttackChanceLight+RealAttackChanceMid
	
	if AttackChoiceResult > HeavyAttackChance:
		AttackArrayPrefix = "Heavy"
	elif AttackChoiceResult > RealAttackChanceLight:
		AttackArrayPrefix = "Mid"
	else:
		AttackArrayPrefix = "Light"
	
	AttackArrayString = str(AttackArrayPrefix)+"AttackNames"
	return AttackArrayString
	
func _custom_physics_process(delta):
	pass
