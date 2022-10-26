extends Node3D
class_name BGProp_Breakable

@export var BreakableAreaPath:NodePath
@onready var BreakableArea:Area3D = get_node(BreakableAreaPath)


@export var DestroySoundPath:AudioStreamPlayer3D


@export var BreakAfterNHits:int = 1
var CurrentHits:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_breakable_values()
	pass # Replace with function body.
func setup_breakable_values():
	BreakableArea.set_collision_mask_value(1,false)
	BreakableArea.set_collision_layer_value(1,false)
	BreakableArea.set_collision_layer_value(4,true)
	BreakableArea.set_collision_mask_value(10,true)
	

func breakable_damaged():
	CurrentHits += 1
	if CurrentHits >= BreakAfterNHits:
		if is_instance_valid(DestroySoundPath):
			DestroySoundPath.play()
		self.visible = false
		BreakableArea.monitoring = false
		BreakableArea.monitorable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
