#By Kyra Gordon as part of KFPS

extends KFPS_EffectBox

##Collider that senses hitboxes and sends relevant data to a linked KFPS_Health node
class_name KFPS_Hurtbox

@export var health:KFPS_Health

func _ready():
	add_to_group("hurtbox")
