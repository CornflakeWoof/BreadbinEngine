extends Area3D
class_name Hitbox_Damage

##ARRAY IS [PHYSDMG,FIRE,LIGHTNING,MAGIC,HOLY,DARK]
@export var HitboxDamageValuesBase:Array[int] =[25,0,0,0,0,0]
@export var MultiplierPerLevel:float = 1.1
@export var HitboxLevel:int = 0
var PreviousHitboxLevel:int = 0
var CurrentHitboxDamageMultiplier:float = 1.0
var PreviousHitboxDamageMultiplier:float = 1.0
@onready var CurrentHitboxDamage:Array[int] = HitboxDamageValuesBase

var Hitbox_Team = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup_initial_values():
	var valuesonvisible = Callable(self,"update_values_on_visible")
	self.set_collision_layer_value(0,false)
	self.set_collision_mask_value(0,false)
	self.set_collision_layer_value(9,true)
	self.set_collision_mask_value(10,true)
	SetCurrentHitboxDamage()
	self.connect("visibility_changed",valuesonvisible)
	self.visible = false

func SetCurrentHitboxDamage():
	CurrentHitboxDamage = HitboxDamageValuesBase
	for x in HitboxDamageValuesBase:
		if is_instance_valid(CurrentHitboxDamage[x]):
			if CurrentHitboxDamage[x] != 0:
				CurrentHitboxDamage[x] = ((int((HitboxDamageValuesBase[x]*MultiplierPerLevel)*HitboxLevel))*CurrentHitboxDamageMultiplier)
		
func update_values_on_visible():
	self.monitoring = visible
	self.monitorable = visible
	if PreviousHitboxDamageMultiplier != CurrentHitboxDamageMultiplier or PreviousHitboxLevel != HitboxLevel:
		PreviousHitboxDamageMultiplier = CurrentHitboxDamageMultiplier
		PreviousHitboxLevel = HitboxLevel
		SetCurrentHitboxDamage()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
