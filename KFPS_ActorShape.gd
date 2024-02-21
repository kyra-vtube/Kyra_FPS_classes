@tool
extends CollisionShape3D

class_name KFPS_ActorShape

@export var height:float

@export var radius:float

func _ready():
	if Engine.is_editor_hint():
		shape = CapsuleShape3D.new()

func _process(_delta):
	if Engine.is_editor_hint():
		shape.height = height
		shape.radius = radius
