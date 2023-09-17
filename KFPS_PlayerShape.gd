extends CollisionShape3D

class_name KFPS_PlayerShape

@export var height:float = 1.5
@export var width:float = 0.25
@export var crouch_speed:float = 9.8

var crouching:bool = false

var second_shape:CollisionShape3D = CollisionShape3D.new()

var second_shape_default:float

func _ready():
	height -= width
	shape = CapsuleShape3D.new()
	shape.height = height
	shape.radius = width
	second_shape = duplicate(true)
	get_parent().call_deferred("add_child",second_shape)
	position.y = -height/2.1
	second_shape.position.y = -height-(width/PI)
	second_shape_default = second_shape.position.y

func _physics_process(delta):
	var height_target:float = second_shape_default
	if get_parent().crouching:
		height_target = position.y
#	position.y = lerpf(position.y, height_target, delta * crouch_speed)
	second_shape.position.y = lerpf(second_shape.position.y, height_target, delta * crouch_speed)
