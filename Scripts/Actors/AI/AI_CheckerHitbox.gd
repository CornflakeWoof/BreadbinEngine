extends Area3D
class_name Hitbox_AIChecker

@export var ArrayToAddTo :String = ""
@export var ReportToOwnersOwner : bool = false
@onready var WhoToReportTo = self.owner if ReportToOwnersOwner == true else self.owner.owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func report_back(nodepathtoadd:NodePath):
	var ArrayToAppend:Array = WhoToReportTo.ArrayToAddTo
	WhoToReportTo.append(nodepathtoadd)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
