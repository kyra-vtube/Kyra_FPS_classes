extends AudioStreamPlayer3D

class_name KFPS_HitSound

@export var sound:AudioStream = load("res://KFPS-classes/example audio/terrain hit.sfxr")

func _ready():
	stream = sound
	doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_PHYSICS_STEP
	play()
	connect("finished", queue_free)
