#By Kyra Gordon as part of KFPS

extends Node

class_name KFPS_Health

##Maximum health value
@export var max_health:float = 100.0

##The amount of damage taken
@export var damage:float = 0.0

##Damage multiplication flags. Format should be "string":multiplication float. When do_damage() is called, the multiplier of any matching flags passed in will be applied
@export var flags:Dictionary

##Damage is allowed to go above max_health and below 0.0 (enables overhealing and overkilling)
@export var overlimit_enabled:bool = false

##Emitted when on_damage is called with a positive damage value
signal on_damage(quantity:float)

##Emitted when on_damage is called with a negative damage value
signal on_heal(quantity:float)

##Emitted when damage == max health
signal on_destroyed(quantity:float)

##Returns the current health level as a percent. Intended for health bars
func get_health_percent() -> float:
	return 1.0 - damage/max_health

##Damage function. Use inverse damage to heal
func do_damage(quantity:float):
	if quantity>0:
		#emit our damage signal
		emit_signal("on_damage",quantity)
	else:
		emit_signal("on_heal",quantity)
	#apply the processed quantity to our damage value
	damage+=quantity
	#if ocerlimit isn't allowed
	if !overlimit_enabled:
		#make sure the damage stays in a legal range
		damage = clamp(damage, 0.0, max_health)
	#check if the destroyed condition is met
	if damage>=max_health:
		emit_signal("on_destroyed",quantity)
