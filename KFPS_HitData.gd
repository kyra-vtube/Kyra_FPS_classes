@tool
extends Resource
class_name KFPS_HitData
@export var damage:float
@export var point:Vector3
@export var normal:Vector3
@export var direction:Vector3
@export var pierce:float
@export var impact:float
@export var shape:int

func _init(
		d:float = 1.0,
		p:Vector3 = Vector3(),
		n:Vector3 = Vector3(),
		di:Vector3 = Vector3(),
		pi:float = 1.0,
		i:float = 1.0,
		s:int = 0
	):
	damage = d
	point = p
	normal = n
	direction = di
	pierce = pi
	impact = i
	shape = s
