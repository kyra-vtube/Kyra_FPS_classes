extends Node

class_name KFPS_Ammobelt

var ammodict:Dictionary = {
	"10mm":100
}

func get_quantity(type:String)->int:
	var result = ammodict.get(type)
	if result == null:
		ammodict[type] = 0
		result = 0
	return result

func add_ammo(quantity:int, type:String = "10mm"):
	if ammodict.get(type)!=null:
		ammodict[type] += quantity
	else:
		ammodict[type] = quantity

func request_ammo(type:String,quantity:int)->int:
	var q = get_quantity(type)
	if q >= quantity:
		ammodict[type]-=quantity
		return quantity
	else:
		return q
