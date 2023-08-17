#V1.0
#By Kyra Gordon on 17/08/23
extends Camera3D

class_name KFPS_PlayerCamera

@export var use_mouselook:bool = false

@export var use_sticklook:bool = false

@export var use_gyrolook:bool = false

@export var mouse_vector:Vector2

@export var stick_vector:Vector2

@export var gyro_vector:Vector2

@export var mouse_sensitivity:float = 0.5

@export var stick_sensitivity:float = 1.0

@export var gyro_sensitivity:float = 0.1

func _input(event):
	if event is InputEventMouseMotion:
		mouse_vector = -event.relative * mouse_sensitivity * float(use_mouselook)

func _process(delta):
	control_look(delta)

func control_look(delta):
	var final_vector:Vector2 = mouse_vector + get_stick_vector() + get_gyro_vector()
	rotate_x(final_vector.y * delta)
	rotation.x = clamp( rotation.x, -1.5, 1.5 )
	get_parent().rotate_y(final_vector.x * delta)
	mouse_vector = Vector2()

func get_stick_vector()->Vector2:
	return Input.get_vector("look down", "look up", "look left", "look right") * stick_sensitivity * float(use_sticklook)

func get_gyro_vector()->Vector2:
	var g = Input.get_gyroscope()*gyro_sensitivity
	return Vector2(g.x,g.y) * gyro_sensitivity * float(use_gyrolook)
