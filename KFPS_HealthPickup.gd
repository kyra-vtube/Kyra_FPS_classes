extends Area3D

class_name KFPS_HealthPickup

@export var amount:float = 30

@export var sound:AudioStream = load("res://KFPS-classes/example audio/pickup.sfxr")

var player:KFPS_HitSound

func _ready():
	collision_mask = KFPS_CollisonLayerClass.layers.actor
	connect("body_entered",floor_pickup)
	player = KFPS_HitSound.new()
	player.sound = sound

func floor_pickup(body):
	if body is KFPS_Player:
		body.health.damage-=amount
		get_tree().get_root().add_child(player)
		queue_free()
