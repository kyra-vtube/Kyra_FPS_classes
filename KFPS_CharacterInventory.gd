#By Kyra Gordon as part of KFPS

extends Node

##Stores items such as keys and other consumables
class_name KFPS_CharacterInventory

##Currently selected item
var item_index:int = 0

func add_item(item:KFPS_Item):
	var already_held = false
	for i in get_children():
		if i.identification == item.identification:
			already_held = true
			i.quantity += 1
			break
	if !already_held:
		if !item.is_inside_tree():
			add_child(item)
		else:
			item.reparent(self, false)
	item.pickup()

func remove_item(item:KFPS_Item):
	item.queue_free()

func give_item(item:KFPS_Item, recipient:KFPS_CharacterInventory):
	item.reparent(recipient)

func get_item_names():
	var list:PackedStringArray = []
	for i in get_children():
		list.append(i.name)
	return list

func change_index(offset:int):
	item_index = wrapi(item_index+offset, 0, get_child_count() - 1)

func use_current_item():
	if get_child_count() >= item_index:
		get_children()[item_index].use()
