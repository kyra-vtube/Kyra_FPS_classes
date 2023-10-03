extends AudioStreamPlayer3D

class_name KFPS_HitSound

@export var _stream:AudioStream

func _ready():
	stream = _stream
	doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_PHYSICS_STEP
	autoplay = true
	connect("finished", queue_free)
