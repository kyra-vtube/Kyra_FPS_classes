#By Kyra Gordon as part of KFPS

extends KFPS_EffectBox

##Collider that senses hitboxes and sends relevant data to a linked KFPS_Health node
class_name KFPS_Hurtbox

signal on_hit(position:Vector3)

@export var health:KFPS_Health

func _ready():
	add_to_group("hurtbox")

func damage(amount, point = Vector3(), angle = Vector3()):
	health.do_damage(amount)
	emit_signal("on_hit", point)
