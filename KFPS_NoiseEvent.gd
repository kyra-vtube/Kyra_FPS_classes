extends Node3D

class_name KFPS_NoiseEvent

var tested:Array = []

var obj:Area3D = Area3D.new()

var shape:SphereShape3D = SphereShape3D.new()

var s_param:PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()

var space:PhysicsDirectSpaceState3D

@export var max_range:float = 1000

@export var data:Dictionary = {}

func _ready():
	data.position = global_position
	add_child(obj)
	shape.radius = 0
	s_param.transform = global_transform
	s_param.collision_mask = KFPS_CollisonLayerClass.layers.hearing
	space = get_world_3d().direct_space_state

func _physics_process(delta):
	shape.radius = clampf(shape.radius+delta*343, 0, max_range)
	if shape.radius == max_range:
		queue_free()
	else:
		s_param.shape = shape
		s_param.transform = global_transform
		var new:Array = space.intersect_shape(s_param)
		for c in new:
			if !tested.has(c):
				c.collider.hear(data)
		tested += new
