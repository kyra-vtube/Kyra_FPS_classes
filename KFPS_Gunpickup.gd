extends Area3D

class_name KFPS_Gunpickup

@export_file(".tscn") var gun_scene = "res://KFPS-classes/example scenes/test gun.tscn"

signal on_grab

var scene


func _ready():
	connect("body_entered",floor_pickup)

func floor_pickup(body):
	if body is KFPS_Player:
		add_to_body(body)

func interact(body):
	add_to_body(body)

func add_to_body(body):
	body.camera.add_gun(load(gun_scene).instantiate())
	emit_signal("on_grab")
	queue_free()
