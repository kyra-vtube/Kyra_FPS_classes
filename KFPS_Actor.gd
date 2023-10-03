#By Kyra Gordon as part of KFPS
extends CharacterBody3D

##The base class for NPCs and any other object that moves around the environment
class_name KFPS_Actor

const FLAT:Vector3 = Vector3(1,0,1)

##Useless position we can use as a placeholder
const SILLY:Vector3 = Vector3(INF,INF,INF)

var gravity:float = 9.8

##The direction the actor aims to go in, in global space
var target_direction:Vector3

##If the actor is trying to jump
var jumping:bool = false

##If the actor is trying to crouch
var crouching:bool = false

##The navigationAgent3D for this actor
var nav:NavigationAgent3D = NavigationAgent3D.new()

var ammobelt:KFPS_Ammobelt = KFPS_Ammobelt.new()

##The navigation goal of this actor
var navigation_goal:Vector3 = SILLY

##A list of velocity impulses to be added to this actor on the coming _physics_process() call
var velocity_buffer:PackedVector3Array = []

##Stores whether navigation was succesful. For use in AI.
var navigation_succesful:bool

##The maximum speed we're going to move at on the ground while walking
@export var top_speed:float = 10

##How fast to slide relative to our top speed
@export var slide_speed_multiplier:float = 1.3

##Overall acceleration rate
@export var acceleration:float = 5.0

##The magnitude that velocity is set to when jumping
@export var jump_impulse:float = 10.0

##Whether the actor will try to reach unreachable areas
@export var navigate_toward_unreachable_area:bool = false 

@export var walljump_enabled:bool = false

var inventory:KFPS_CharacterInventory = KFPS_CharacterInventory.new()

var health:KFPS_Health = KFPS_Health.new()

func _ready():
	collision_layer = KFPS_CollisonLayerClass.layers["actor"
	] && KFPS_CollisonLayerClass.layers["terrain"] && KFPS_CollisonLayerClass.layers["damage"]
	layer_setup()
	for i in [nav, inventory, health]:
		add_child(i)

func _physics_process(delta):
	get_collision_state()
	navigation_succesful = navigate()
	manage_velocity(delta)
	jump()
	move_and_slide()

##Converts local target direction into velocity, handles acceleration and gravity
func manage_velocity(delta):
	var y = velocity.y
	velocity = velocity.move_toward(target_direction * top_speed, delta*acceleration)
	velocity.y = y - (gravity*delta)
	for i in velocity_buffer:
		velocity+=i

##Mimics the functionality of the function of the same name in the rigidbody class
func apply_central_impulse(impulse:Vector3):
	velocity_buffer.append( impulse )

##Alias for apply central impulse
func apply_impulse(impulse:Vector3, _position:Vector3 = Vector3()):
	apply_central_impulse(impulse)

##Handles jumping off of any solid surfaces
func jump():
	if jumping:
		var jump_direction:Vector3 = Vector3.ZERO
		if is_on_floor():
			jump_direction += Vector3.UP
		if walljump_enabled:
			if is_on_wall() and target_direction.dot( get_wall_normal() ) < 0 and crouching:
				jump_direction += get_wall_normal()
			if is_on_ceiling() and crouching:
				jump_direction += Vector3.DOWN
		velocity += jump_direction.normalized() * jump_impulse
	jumping = false

##validates the is_on_floor, is_on_wall and is_on_ceiling functions and their associated angle functions, for jumping and sliding
func get_collision_state():
	#Store the current velocity
	var stored_vel = velocity
	#Reset velocity and run move_and_slide to check for collisions
	velocity = Vector3()
	move_and_slide()
	#Restore previous velocity
	velocity = stored_vel

func navigate():
	if navigation_goal != SILLY:
		nav.target_position = navigation_goal
		var reach = nav.is_target_reachable()
		var cancel = !navigate_toward_unreachable_area
		if (reach == cancel) || (reach && !cancel):
			# reach and cancel == go there
			# !reach and !cancel == go there
			# !reach and cancel == stop
			# reach and !cancel == go there
			target_direction = (global_position * FLAT).direction_to(nav.get_next_path_position() * FLAT)
			return true
		else:
			return false
	else:
		return false

func clear_navigation():
	navigation_goal = SILLY

func layer_setup():
	var layers:Dictionary = KFPS_CollisonLayerClass.layers
	collision_layer = layers["terrain"] && layers["damage"] && layers["damage"] && layers["visibility"]
