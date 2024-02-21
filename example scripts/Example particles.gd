extends KFPS_Particles

func _ready():
	$GPUParticles3D.emitting = true
	$dust_poof.emitting = true


func _physics_process(delta):
	$OmniLight3D.light_energy = lerpf( $OmniLight3D.light_energy, 0.0, delta*10 )
	
