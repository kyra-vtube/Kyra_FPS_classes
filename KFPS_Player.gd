#By Kyra Gordon as part of KFPS

extends KFPS_Actor

class_name KFPS_Player

signal death

@export var toggle_crouch:bool = false

var inventory:KFPS_CharacterInventory = KFPS_CharacterInventory.new()

var shape:KFPS_PlayerShape = KFPS_PlayerShape.new()

var camera:KFPS_PlayerCamera = KFPS_PlayerCamera.new()

var pause:KFPS_Pause = KFPS_Pause.new()

var health:KFPS_Health = KFPS_Health.new()

func _ready():
	add_to_group("player")
	add_to_group("hurtbox")
	for n in [shape, camera, pause, inventory, health]:
		add_child(n)

func _process(_delta):
	collect_input()

func _physics_process(delta):
	get_collision_state()
	manage_velocity(delta)
	jump()
	move_and_slide()

func collect_input():
	var move:Vector2 = Input.get_vector(
		"move left",
		"move right",
		"move forward",
		"move backward")
	target_direction = global_transform.basis * Vector3( move.x, 0, move.y )
	jumping = Input.is_action_pressed("jump")
	if toggle_crouch:
		if Input.is_action_just_pressed("crouch"):
			crouching = !crouching
	else:
		crouching = Input.is_action_pressed("crouch")
