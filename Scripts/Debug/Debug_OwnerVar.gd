extends Label

@export var VariableName :String = "Variable"
@export var actualvariable : String = "position.x"

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node("/root/GlobalSystemSettings").DebugMode == false:
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str(VariableName)+" "+str(owner.get(actualvariable))
	pass
