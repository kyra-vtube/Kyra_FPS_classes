extends Node3D

class_name KFPS_Tool

signal on_discard

signal on_use

func discard():
	emit_signal("on_discard")

func use():
	emit_signal("on_use")
