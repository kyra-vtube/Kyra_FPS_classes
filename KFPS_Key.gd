#By Kyra Gordon as part of KFPS

extends KFPS_EffectBox

class_name KFPS_Key

@export var lock:KFPS_Lock

func _ready():
	connect("effect", collect_key)
	monitoring = false

func collect_key(list:Array):
	for i in list:
		if i.is_in_group("player"):
			monitorable = false
			hide()
			reparent(i.inventory)
