#By Kyra Gordon as part of KFPS
extends CharacterBody3D

##The base class for NPCs and any other object that moves around the environment
class_name KFPS_Actor

const FLAT:Vector3 = Vector3(1,0,1)

##Useless position we can use as a placeholder
const SILLY:Vector3 = Vector3(INF,INF,INF)

##The direction the actor aims to go in, in global space
var target_direction:Vector3

##If the actor is trying to jump
var jumping:bool = false

##If the actor is trying to crouch
var crouching:bool = false
 
##If the actor is trying to slide
var slide_direction:Vector3

##The navigationAgent3D for this actor
var nav:NavigationAgent3D

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
@export var acceleration:float = 5

##The magnitude that velocity is set to when jumping
@export var jump_impulse:float = 10.0

##Whether the actor will try to reach unreachable areas
@export var navigate_toward_unreachable_area:bool = false 

func _ready():
	nav = NavigationAgent3D.new()
	add_child(nav)

func _physics_process(delta):
	get_collision_state()
	navigation_succesful = navigate()
	manage_velocity(delta)
	jump()
	slide(delta)
	move_and_slide()

##Converts local target direction into velocity, handles acceleration and gravity
func manage_velocity(delta):
	var y = velocity.y
	velocity = velocity.move_toward(target_direction * top_speed, delta*acceleration)
	velocity.y = y - (9.8*delta)
	for i in velocity_buffer:
		velocity+=i

##Mimics the functionality of the function of the same name in the rigidbody class
func apply_central_impulse(impulse:Vector3):
	velocity_buffer.append( impulse )

##Alias for apply central impulse
func apply_impulse(impulse:Vector3, position:Vector3 = Vector3()):
	apply_central_impulse(impulse)

##Handles jumping off of any solid surfaces
func jump():
	if jumping:
		var jump_direction:Vector3
		if is_on_floor():
			jump_direction += Vector3.UP
		if is_on_wall() and target_direction.dot( get_wall_normal() ) and crouching:
			jump_direction += get_wall_normal()
		if is_on_ceiling() and crouching:
			jump_direction += Vector3.DOWN
		velocity += jump_direction.normalized() * jump_impulse
		slide_direction = Vector3()
		crouching = false
	jumping = false

##Handles sliding along the ground
func slide(delta):
	#Check if we're crouching and on the floor and moving
	if crouching and is_on_floor() and !target_direction.is_zero_approx():
		#If ther isn't already a valid slide vector, make one from the direction we're holding.
		if slide_direction.is_zero_approx():
			slide_direction = target_direction
		#otherwise construct it from our stats and apply that to our velocity
		else:
			#Inputting a different direction cancels the slide
			if target_direction.dot( slide_direction )>0:
				velocity = slide_direction * top_speed * slide_speed_multiplier
			else:
				slide_direction = Vector3()
	#If our check for the slide condition fails, then break out of the slide state
	else:
		slide_direction = Vector3()
	slide_direction = slide_direction.lerp(Vector3(),delta)

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

