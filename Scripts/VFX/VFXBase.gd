extends Node3D
class_name VFX_Base

@export var VFXTimeout:float = 1.0

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	var vfxremove = Callable(self,"_on_vfx_timeout")
	var vfxtimer = Timer.new()
	self.add_child(vfxtimer)
	vfxtimer.name = "VFXTimer"
	vfxtimer.wait_time = VFXTimeout
	vfxtimer.autostart = true
	vfxtimer.one_shot = true
	vfxtimer.connect("timeout",vfxremove)

func _ready():
	if is_instance_valid(get_node("GPUParticles3D")):
		get_node("GPUParticles3D").emitting = true
	elif is_instance_valid(get_node("CPUParticles3D")):
		get_node("CPUParticles3D").emitting = true
	pass # Replace with function body.

func _on_vfx_timeout():
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
