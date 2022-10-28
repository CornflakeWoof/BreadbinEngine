extends Node

const SaveFilePath:String = "user://BreadbinSave.save"
const DefaultWeaponAttackAnimation:String="HumanoidBase/walk"
var DebugMode:bool = true

##TEAMS - 0-No team,1-Players,2-FriendlyNPCs,3-FriendliesYouCanHit,4-HostileNPCs,5-EnemiesA,6-EnemiesB
var Teams_CanHurt : Array = [[],[0,3,4,5,6],[4,5,6],[4,5,6],[1,2,3],[1,2,3,4,6],[1,2,3,4,5]]

var Camera_HSpeed : int = 10
var Camera_VSpeed : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
