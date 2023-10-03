#By Kyra Gordon as part of KFPS

extends Area3D

class_name KFPS_EffectBox

var timer:Timer

@export_enum("ONCE", "INTERVAL") var EFFECT_MODE = 0

@export_enum("NONE","CONTACT","TIMER") var DESTROY_CONDITION = 0

@export var interval:float = 0.1

@export var ignore_list:Array[CollisionObject2D] = []

var contacts:Array[CollisionObject2D] = []

func _ready():
	if EFFECT_MODE == 1:
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", restart)
		timer.start(interval)
	for i in ["area_entered","body_entered","area_exited","body_exited"]:
		connect(i,contact_change)

##Called when anything enters or exits the area so the effect timer can be paused when the area is empty
func contact_change(obj):
	effect(obj)

##Restarts the timer
func restart():
	timer.start(interval)

##Change this to modify the effect of the area
func effect(obj):
	print(obj)
