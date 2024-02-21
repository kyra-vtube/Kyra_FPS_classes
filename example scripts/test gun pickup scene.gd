extends RigidBody3D

func _ready():
	$KFPS_Gunpickup.monitoring = false
	collision_layer = KFPS_CollisonLayerClass.layers["interactive"]

func _on_kfps_gunpickup_on_grab():
	queue_free()

func interact(body):
	$KFPS_Gunpickup.interact(body)
