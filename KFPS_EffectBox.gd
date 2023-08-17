#V1.0
#By Kyra Gordon on 17/08/23

extends Area3D

class_name KFPS_EffectBox

var timer:Timer

@export_enum("ONCE", "INTERVAL") var EFFECT_MODES

@export var effect_modes:int = EFFECT_MODES.ONCE

@export var interval:float = 0.1

signal effect

func _ready():
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
	timer.paused = !(has_overlapping_areas() || has_overlapping_bodies())

##Restarts the timer
func restart():
	timer.start(interval)
	emit_signal("effect")
