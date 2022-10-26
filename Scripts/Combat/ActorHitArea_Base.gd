extends Area3D
class_name ActorHitArea

@export var ConnectedToActorPath:NodePath
@onready var ConnectedToActor = get_node(ConnectedToActorPath)

@export var HitAreaDamageMultiplier:float = 1.0

# Called when the node enters the scene tree for the first time.

func _enter_tree():
	if !is_instance_valid(ConnectedToActor):
		print_debug(str(self.name)+" failed to connect to "+str(ConnectedToActorPath)+", removing.")
		self.queue_free()

func _ready():
	self.set_collision_layer_value(1,false)
	self.set_collision_mask_value(1,false)
	self.set_collision_layer_value(11,true)
	self.set_collision_mask_value(10,true)
	connect_hitbox()
	pass # Replace with function body.

func connect_hitbox():
	var ActorCallable = Callable(ConnectedToActor,"_ActorHitArea_entered")
	if ConnectedToActor.has_method("_ActorHitArea_entered"):
		self.connect("area_entered",ActorCallable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
