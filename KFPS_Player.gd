#By Kyra Gordon as part of KFPS

extends KFPS_Actor

class_name KFPS_Player

signal death

@export var toggle_crouch:bool = false

@export var stamina:KFPS_Stamina

@export var jump_cost:float = 0

@export var height:float = 1.5

var has_stamina:bool

var shape:KFPS_PlayerShape = KFPS_PlayerShape.new()

var camera:KFPS_PlayerCamera = KFPS_PlayerCamera.new()

var pause:KFPS_Pause = KFPS_Pause.new()

var soundplayer:AudioStreamPlayer = AudioStreamPlayer.new()

var p_death:KFPS_PlayerDeath = KFPS_PlayerDeath.new()

var blocking:bool = false

func _ready():
	has_stamina = stamina!=null
	layer_setup()
	add_to_group("player")
	add_to_group("hurtbox")
	layer_setup()
	for n in [shape, camera, pause, inventory, ammobelt, health, soundplayer, vis, p_death]:
		add_child(n)
	health.add_child(KFPS_PlayerHealthBar.new())
	health.connect("on_destroyed",p_death.die)
	vis.tags.append("player")

func _process(_delta):
	collect_input()

func _physics_process(delta):
	blocking = Input.is_action_pressed("block")
	get_collision_state()
	manage_velocity(delta)
	if jumping:
		if has_stamina && touching:
			if stamina.use(jump_cost):
				jump()
		else:
			jump()
	move_and_slide()
	was_touching = touching

func collect_input():
	var move:Vector2 = Input.get_vector(
		"move left",
		"move right",
		"move forward",
		"move backward")
	target_direction = global_transform.basis * Vector3( move.x, 0, move.y )
	jumping = Input.is_action_just_pressed("jump")
	if toggle_crouch:
		if Input.is_action_just_pressed("crouch"):
			crouching = !crouching
	else:
		crouching = Input.is_action_pressed("crouch")
