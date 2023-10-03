extends Node

class_name KFPS_Item

@export var quantity:int = 1

@export var identification:String = "item"

##Executed on use by the actor holding it
func use():
	quantity-=1
	if quantity<1:
		queue_free()
	on_use()

##Change this to add new behaviours on use of the item
func on_use():
	pass

##Executed on pickup by an actor
func pickup():
	pass
