extends Node

#FORMAT - ID:[Name of Attack,Damage Multiplier]

var attacktable2 : Dictionary = {
	100:["HumanoidBase/sword_rslash",1.0],
	101:["HumanoidBase/sword_backslash",1.0],
	102:["HumanoidBase/sword_twirlslash",1.0]
}

var attacktable : Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	load_csv()

func load_csv():
	var dicttoaddto : Dictionary = attacktable
	var csvfile = FileAccess.new()
	csvfile = FileAccess.open("res://Data/AttackTable.tres",FileAccess.READ)
	while !csvfile.eof_reached():
		var csvdata = csvfile.get_csv_line()
		for csvstate in csvdata.size()-1:
			var ID = csvdata[0]
			if ID != "AttackID":
				ID = str_to_var(ID)
			var AttackAnimationPath = csvdata[1]
			var AttackMultiplier = csvdata[2]
			AttackMultiplier = str_to_var(AttackMultiplier)
			dicttoaddto[ID]=[AttackAnimationPath,AttackMultiplier]
	
	dicttoaddto.erase("AttackID")
	print(dicttoaddto)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
