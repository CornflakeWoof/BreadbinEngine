extends ActorBase


## KEY NODES

@export var VisionArea:Area3D

## AI PREFERENCES

@export var AttackChanceLight:int = 70
var RealAttackChanceLight :float = 0.2
@export var AttackChanceMid:int = 60
var RealAttackChanceMid : float = 0.2
@export var AttackChanceHeavy:int = 50
var RealAttackChanceHeavy : float = 0.2 

## ATTACK NAME ARRAYS

@export var LightAttackNames:Array[String]
var LightAttackNumber:int = 0
@export var MidAttackNames:Array[String]
var MidAttackNumber:int = 0
@export var HeavyAttackNames:Array[String]
var HeavyAttackNumber:int = 0

func _ready():
	InitializeAIActor()

func InitializeAIActor():
	UpdateAttackNumbers()
	CalculateAttackChances()

# ATTACK ARRAY FUNCTIONS
func UpdateAttackNumbers():
	LightAttackNumber = LightAttackNames.size()
	MidAttackNumber = MidAttackNames.size()
	HeavyAttackNumber = HeavyAttackNames.size()

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
