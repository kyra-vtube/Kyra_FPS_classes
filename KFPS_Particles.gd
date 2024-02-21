extends GPUParticles3D

class_name KFPS_Particles

func _ready():
	var t = Timer.new()
	add_child(t)
	t.connect("timeout",queue_free)
	t.start(lifetime)
	emitting = true
