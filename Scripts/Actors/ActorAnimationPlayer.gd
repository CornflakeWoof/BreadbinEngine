extends AnimationPlayer
class_name ActorAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func call_function_on_owner(funcname:String="",ownersowner:bool=true):
	var target:Node = owner
	if ownersowner == true:
		target = owner.owner
		
	if target.has_method(funcname):
		target.call_deferred(funcname)
		
func allow_combo():
	#print_debug("Calling allow_combo on "+str(owner.owner.name))
	call_function_on_owner("allow_combo",true)

func end_combo():
	call_function_on_owner("stop_attacking",true)

func stop_rolling():
	call_function_on_owner("stop_rolling",true)
	
func push_actor_forward(amount:float=3.0):
	if owner.owner.has_method("add_actor_forward_force"):
		owner.owner.add_actor_forward_force(amount)
	
func change_actor_rotation_multiplier(amount:float=1.0,amountmovement:float=1.0):
	var actor = owner.owner
	if actor.has_method("change_rotation_multiplier"):
		#print_debug(str(actor.name)+" has change_rotation_multiplier, running!")
		actor.call_deferred("change_rotation_multiplier",amount,amountmovement)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
