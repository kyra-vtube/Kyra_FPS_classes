#By Kyra Gordon as part of KFPS
@tool

extends KFPS_EffectBox

##Collider that senses hitboxes and sends relevant data to a linked KFPS_Health node
class_name KFPS_Hurtbox

signal on_hit(position:Vector3)

var body:KFPS_Actor

func _ready():
	var b = get_parent()
	while !b is KFPS_Actor:
		b = b.get_parent()
	body = b
	for i in 31:
		set_collision_layer_value(i+1,false)
	collision_layer = KFPS_CollisonLayerClass.layers["damage"]

func damage(d:KFPS_HitData):
	body.health.do_damage(d.amount)
	emit_signal("on_hit", d.point)
