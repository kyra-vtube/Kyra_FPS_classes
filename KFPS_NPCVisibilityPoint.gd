extends Node3D

##Reference points visible to KFPS_NPCEyes
class_name KFPS_NPCVisibilityPoint

@export var tags:PackedStringArray

func _ready():
	add_to_group("visible")

func _physics_process(_delta):
	pass
