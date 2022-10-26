extends Node

const Global_Stamina_Regen_Rate:int = 4

signal save_all_actors

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func save_actors():
	emit_signal("save_all_actors")
