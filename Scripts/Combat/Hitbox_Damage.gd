extends Area3D
class_name Hitbox_Damage


@export var MultiplierPerLevel:float = 0.1
@export var HitboxLevel:int = 0
var PreviousHitboxLevel:int = 0
var HitboxDamageMultiplier = 1.0
var TotalDamageMultiplier = 1.0

var MyWeapon = self

signal hitactor
signal hitwall

var Hitbox_Team = 0

# Called when the node enters the scene tree for the first time.

func _enter_tree():
	self.visible = false
	self.monitoring =false
	self.monitorable = false

func _ready():
	setup_initial_values()
	pass # Replace with function body.

func setup_initial_values():
	#FORCE HITBOX'S MASK TO CORRECT VALUES - LOOKING FOR LAYER 10 (ACTORHITBOXES) FROM LAYER 9
	self.set_collision_layer_value(1,false)
	self.set_collision_mask_value(1,false)
	self.set_collision_layer_value(10,true)
	self.set_collision_mask_value(11,true)
	
	#if get_node("/root/GlobalSystemSettings").DebugMode == true:
		#dmghitboxdebug = load()
	
	if "BaseDamage" in owner:
		MyWeapon = owner
		print_debug(str(self.name)+" set MyWeapon to "+str(owner.name))
	
	if "Actor_Team" in owner.owner.owner:
		Hitbox_Team = owner.owner.owner.Actor_Team
	elif "Actor_Team" in owner.owner:
		Hitbox_Team = owner.owner.Actor_Team

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
