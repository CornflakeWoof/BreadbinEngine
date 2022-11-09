extends Node

const Global_Stamina_Regen_Rate:int = 4

##TEAMS - 0-No team,1-Players,2-FriendlyNPCs,3-FriendliesYouCanHit,4-HostileNPCs,5-EnemiesA,6-EnemiesB
const Teams_CanHurt : Array = [[],[0,3,4,5,6],[4,5,6],[4,5,6],[1,2,3],[1,2,3,4,6],[1,2,3,4,5]]


signal save_all_actors

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func save_actors():
	emit_signal("save_all_actors")
