extends Node

class_name KFPS_PlayerDeath

func die(_a):
	get_tree().get_nodes_in_group("pause")[0].death()
