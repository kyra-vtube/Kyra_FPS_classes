extends Node

class_name KFPS_CameraJuicer

@onready var cam:KFPS_PlayerCamera = get_parent()

@onready var player:KFPS_Player = cam.get_parent()

var old_player_velocity:Vector3

var velocity:Vector3

@export var return_speed:float = 10

var max_camera_distance = 0.1

func _physics_process(delta):
	detect_friction()
	direction_change()
	move_camera(delta)
	return_camera(delta)
	old_player_velocity = pvel()

func pvel():
	return player.velocity

func return_camera(delta):
	cam.h_offset = lerpf(cam.h_offset, 0, delta * return_speed)
	cam.v_offset = lerpf(cam.v_offset, 0, delta * return_speed)
	velocity = lerp(velocity, Vector3(), delta * return_speed)

func shake(intensity:float):
	var out = KFPS_Shake.shake2D(intensity)
	velocity.x += out.x
	velocity.y += out.y

func direction_change():
	velocity -= (cam.global_transform.basis*(pvel()-old_player_velocity))

func detect_friction():
	if (!pvel().is_zero_approx() && player.target_direction.is_zero_approx() && player.is_on_floor()
	) || (player.is_on_wall() || player.is_on_ceiling()) && !pvel().is_zero_approx():
		shake((pvel().length()/player.top_speed)/3)

func move_camera(delta):
	cam.v_offset += velocity.y*delta
	cam.h_offset += velocity.x*delta
	cam.v_offset = clampf(cam.v_offset, -max_camera_distance, max_camera_distance)
	cam.h_offset = clampf(cam.h_offset, -max_camera_distance, max_camera_distance)
	velocity *= 0
