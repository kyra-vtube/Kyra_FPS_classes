extends Area3D

class_name KFPS_AmmoPickup

@export var ammo_name:String = "10mm"

@export var quantity:int = 30

@export var sound:AudioStream = load("res://KFPS-classes/example audio/pickup.sfxr")

var player:KFPS_HitSound

func _ready():
	collision_mask = KFPS_CollisonLayerClass.layers.actor
	connect("body_entered",floor_pickup)
	player = KFPS_HitSound.new()
	player.sound = sound

func floor_pickup(body):
	if body is KFPS_Player:
		body.ammobelt.add_ammo(quantity,ammo_name)
		get_tree().get_root().add_child(player)
		queue_free()
