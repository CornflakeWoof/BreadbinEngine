extends Node

const SaveFilePath:String = "user://BreadbinSave.save"
const DefaultWeaponAttackAnimation:String="HumanoidBase/walk"
var DebugMode:bool = true



var Camera_HSpeed : int = 10
var Camera_VSpeed : int = 10



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
