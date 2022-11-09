extends Node3D
class_name BGProp_Breakable

@export var BreakableArea:Area3D
@export var StaticBody:StaticBody3D

##PATH FROM Scenes/VFX/ WITHOUT .tscn EXTENSION
@export var VFX_Scene_Break_Path : String = "Breakables/WoodBreak"

@export var DestroySoundPath:AudioStreamPlayer3D


@export var BreakAfterNHits:int = 1
var CurrentHits:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_breakable_values()
	pass # Replace with function body.
func setup_breakable_values():
	var BreakableHit = Callable(self,"_area_entered")
	BreakableArea.set_collision_mask_value(1,false)
	BreakableArea.set_collision_layer_value(1,false)
	BreakableArea.set_collision_layer_value(12,true)
	BreakableArea.set_collision_mask_value(10,true)
	StaticBody.set_collision_mask_value(1,false)
	StaticBody.set_collision_layer_value(1,false)
	StaticBody.set_collision_layer_value(4,true)
	BreakableArea.connect("area_entered",BreakableHit)
	
func breakable_damaged():
	CurrentHits += 1
	if CurrentHits >= BreakAfterNHits:
		if is_instance_valid(DestroySoundPath):
			DestroySoundPath.play()
		self.visible = false
		BreakableArea.set_deferred("monitoring", false)
		BreakableArea.set_deferred("monitorable", false)
		if VFX_Scene_Break_Path != "":
			spawn_break_scene()
		StaticBody.process_mode = PROCESS_MODE_DISABLED

func spawn_break_scene():
	var breakvfxscene:PackedScene = load("res://Scenes/VFX/"+str(VFX_Scene_Break_Path)+".tscn")
	var breakvfxsceneinstance = breakvfxscene.instantiate()
	get_parent().add_child(breakvfxsceneinstance)
	breakvfxsceneinstance.position = self.position
	
func _area_entered(area:Area3D):
	print("Area Entered!")
	if area.get_collision_layer_value(10):
		breakable_damaged()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
