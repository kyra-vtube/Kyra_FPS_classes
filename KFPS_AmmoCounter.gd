extends Control
##Add to a gun to give it an ammo readout
class_name KFPS_AmmoCounter

@export var magazine:Label

@export var stockpile:Label

var ammo_name:String

func _ready():
	ammo_name = gp().ammo_name

func _physics_process(_delta):
	magazine.text = str(gp().mag)+"/"+str(gp().mag_capacity)
	stockpile.text = str(gp().wielder.ammobelt.get_quantity(ammo_name))+" "+ammo_name
	visible = gp().visible

func gp()->KFPS_Gun:
	return get_parent()
