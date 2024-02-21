extends StaticBody3D

class_name KFPS_DestroyableTerrain

@export var segment_health:float

var healths:PackedFloat32Array

@export var toughness:float = 10

var chunks:int

func _ready():
	for i in get_children():
		healths.append(segment_health)
	chunks = get_child_count()

func damage(damage:float,
		position:Vector3 = Vector3(),
		normal:Vector3 = Vector3(),
		shape:int = 0):
	var hit_shape = get_children()[shape]
	if damage>=toughness:
		healths[shape]-=damage
	if healths[shape] < 0:
		hit_shape.disabled = true
		hit_shape.hide()
		chunks-=1
	if chunks==0:
		queue_free()
