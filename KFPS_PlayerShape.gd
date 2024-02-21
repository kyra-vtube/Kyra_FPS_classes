extends CollisionShape3D

class_name KFPS_PlayerShape

var width:float

##multiple of height to set width to

var width_ratio:float = .15

@export var crouch_speed:float = 9

var height:float

var crouching:bool = false

var second_shape:CollisionShape3D = CollisionShape3D.new()

var second_shape_default:float

var crouch_amount:float = 0

func _ready():
	height = get_parent().height
	width = height*width_ratio
	height -= width
	height/=2
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
	var crouch_difference = position.y-second_shape_default
	if get_parent().crouching:
		height_target = lerpf(second_shape_default, position.y, Input.get_action_strength("crouch"))
	second_shape.position.y = lerpf(
		second_shape.position.y, height_target, delta * crouch_speed)
	crouch_amount = 1.0-((position.y-second_shape.position.y)/crouch_difference)
