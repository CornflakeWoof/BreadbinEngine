extends Node3D
class_name StatAdjuster

@export var StatAdj1_StatName:String = ""
@export var StatAdj1_IntIfTrueFloatIfNot = true
@export var StatAdj1_AmountInt:int = 1
@export var StatAdj1_AmountFloat:float = 1.0
@export var StatAdj1_TickRate:float = 1.0

@export var StatAdj2_StatName:String = ""
@export var StatAdj2_IntIfTrueFloatIfNot = true
@export var StatAdj2_AmountInt:int = 1
@export var StatAdj2_AmountFloat:float = 1.0
@export var StatAdj2_TickRate:float = 1.0

@export var StatAdj3_StatName:String = ""
@export var StatAdj3_IntIfTrueFloatIfNot = true
@export var StatAdj3_AmountInt:int = 1
@export var StatAdj3_AmountFloat:float = 1.0
@export var StatAdj3_TickRate:float = 1.0

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	var StatAdjArray : Array = ["StatAdj1","StatAdj2","StatAdj3"]
	#CHECK EACH STATADJ FOR A LISTED STATNAME, THEN CREATE AND CONNECT A TICKRATE TIMER IF SO
	for s in StatAdjArray:
		var StatAdj = StatAdjArray[s]
		if get(str(StatAdj)+"_StatName") != "":
			create_statadj_timer(StatAdj,get(str(StatAdj)+"_TickRate"))

func _ready():
	pass # Replace with function body.

func apply_statadj_effects():
	var 
	if StatAdj1_StatName != "":
		StatAdj1_

func create_statadj_timer(nametoset:String="NewTimer",timetoset:float=1.0):
	var stattimer = Timer.new()
	stattimer.name = nametoset
	stattimer.wait_time = timetoset
	stattimer.autostart = true
	stattimer.one_shot = false
	if 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
