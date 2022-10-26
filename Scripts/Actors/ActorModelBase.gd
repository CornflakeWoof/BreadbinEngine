extends Node3D
class_name ActorModel

##WEAPON STUFF
@export var LHandWeapon_Bone : BoneAttachment3D
@export var RHandWeapon_Bone : BoneAttachment3D
var Current_Weapon_R_Name:String =""
var Current_Weapon_R : Node = self
var Current_Weapon_L_Path:String =""
var Current_Weapon_L : Node = self
@export var RootmotionAttachment_Bone : BoneAttachment3D
@export var Skeleton : Skeleton3D
var Propulsion:float = 0

func affect_weapon_hitboxes(setto:bool,hitboxes:Array=[0],WhichWeapon:Object=self):
	if WhichWeapon != self:
		if is_instance_valid(WhichWeapon.Hitboxes):
			for h in hitboxes:
				if is_instance_valid(WhichWeapon.Hitboxes[h]):
					WhichWeapon.Hitboxes[hitboxes[h]].visible=setto
				else:
					WhichWeapon.Hitboxes[hitboxes[0]].visible=setto
		else:
			print_debug("Can't find Weapon Hitboxes array for "+str(WhichWeapon.name))

func create_propulsion_timer():
	var proptimer = Timer.new()
	var proptimercallable = Callable(self,"update_propulsion")
	proptimer.name = "UpdatePropulsionTimer"
	proptimer.wait_time = 0.2
	proptimer.autostart = true
	proptimer.one_shot = false
	proptimer.connect("timeout",proptimercallable)
	self.add_child(proptimer)
	proptimer.start()
	
func update_propulsion():
	var boneprop:Vector3 = Skeleton.get_bone_pose_position(0)
	Propulsion = boneprop.z
## COMBAT FUNCTIONS

# Called when the node enters the scene tree for the first time.
func _ready():
	create_propulsion_timer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
