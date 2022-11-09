extends Node3D
class_name ActorModel

##WEAPON STUFF

##CHARACTER ATTACH POINTS
@export var LHandWeapon_AttachPoint : Node3D
@export var RHandWeapon_AttachPoint : Node3D
@export var Skeleton : Skeleton3D

@export var Armor_HelmPoint : Node3D = self
@export var Armor_ChestPoint : Node3D = self
@export var Armor_LPauldronPoint : Node3D = self
@export var Armor_RPauldronPoint : Node3D = self

# Called when the node enters the scene tree for the first time.
func _ready():
	#Skeleton.set_bone_pose_position(0,Vector3(0,0,0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
