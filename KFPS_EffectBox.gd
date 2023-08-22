#By Kyra Gordon as part of KFPS

extends Area3D

class_name KFPS_EffectBox

var timer:Timer

@export_enum("ONCE", "INTERVAL") var EFFECT_MODE

@export var interval:float = 0.1

signal effect(list:Array)

func _ready():
	if EFFECT_MODE == EFFECT_MODE.INTERVAL:
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", restart)
		timer.start(interval)
	connect("area_entered", contact_change)
	connect("body_entered", contact_change)
	connect("area_exited", contact_change)
	connect("body_exited", contact_change)

##Called when anything enters or exits the area so the effect timer can be paused when the area is empty
func contact_change():
	timer.paused = !(has_overlapping_areas() || has_overlapping_bodies()) && EFFECT_MODE == EFFECT_MODE.ONCE
	fire_effect()

##Restarts the timer
func restart():
	timer.start(interval)
	fire_effect()

func fire_effect():
	emit_signal("effect",get_overlapping_areas()+get_overlapping_bodies())
