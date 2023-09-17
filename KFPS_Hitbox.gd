#By Kyra Gordon as part of KFPS

extends KFPS_EffectBox

class_name KFPS_Hitbox

@export var damage:float = 1

@export var damage_flags:PackedStringArray = []

func _ready():
	connect("effect", hit)

func hit(list:Array):
	for i in list:
		if i.is_in_group("hurtbox"):
			i.health.do_damage(damage,damage_flags)
		elif i.has_method("do_damage"):
			i.do_damage(damage, damage_flags)
