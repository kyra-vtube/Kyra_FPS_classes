extends Area3D

class_name KFPS_Gunpickup

@export_file(".tscn") var gun_scene = "res://KFPS-classes/example scenes/test gun.tscn"

var scene

signal on_grab

func _ready():
	collision_mask = KFPS_CollisonLayerClass.layers.actor
	connect("body_entered",floor_pickup)

func floor_pickup(body):
	if body is KFPS_Player:
		add_to_body(body)

func interact(body):
	add_to_body(body)

func add_to_body(body):
	if body.camera.add_gun(load(gun_scene).instantiate()):
		queue_free()
