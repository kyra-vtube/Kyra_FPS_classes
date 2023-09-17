extends Node3D

class_name KFPS_Tool

var using:bool = false

var using_secondary:bool = false

var discarding:bool = false

func _input(event):
	using = Input.is_action_pressed("use tool primary")
	using_secondary = Input.is_action_pressed("use tool secondary")
	discarding = Input.is_action_pressed("discard tool")
