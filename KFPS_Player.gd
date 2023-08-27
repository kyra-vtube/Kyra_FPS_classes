#By Kyra Gordon as part of KFPS

extends KFPS_Actor

class_name KFPS_Player

@export var inventory:KFPS_CharacterInventory

@export var toggle_crouch:bool = false

func _ready():
	add_to_group("player")

func _process(delta):
	collect_input()

func _physics_process(delta):
	get_collision_state()
	manage_velocity(delta)
	jump()
	slide(delta)
	if Input.is_action_just_released("crouch"):
		can_slide = true
	move_and_slide()

func collect_input():
	var move:Vector2 = Input.get_vector(
		"move left",
		"move right",
		"move forward",
		"move backward")
	target_direction = global_transform.basis * Vector3( move.x, 0, move.y )
	jumping = Input.is_action_pressed("jump")
	if toggle_crouch and Input.is_action_just_pressed("crouch"):
		crouching = !crouching
	else:
		crouching = Input.is_action_pressed("crouch")
