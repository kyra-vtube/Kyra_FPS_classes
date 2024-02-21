extends Node

##Node to be added to a KFPS_Player to add sprint functions
class_name KFPS_Sprint

var parent:KFPS_Actor

@export var sprint_speed:float = 20

var original_speed:float

@export var sprint_acceleration:float = 10

var original_acceleration:float

@export var sprint_jump_impulse:float = 15

var original_jump:float

var audio:AudioStreamPlayer = AudioStreamPlayer.new()

@export var sprint_sound:AudioStream

@export var stamina_cost:float = 0

@export var stamina:KFPS_Stamina

func _ready():
	add_child(audio)
	audio.stream = sprint_sound
	parent = get_parent()
	original_speed = parent.top_speed
	original_acceleration = parent.acceleration
	original_jump = parent.jump_impulse

func _physics_process(delta):
	var strength = Input.get_action_strength("sprint")
	if strength>0 && check_stamina(delta*stamina_cost*strength) && !Input.is_action_pressed("crouch"):
		parent.top_speed = lerp(original_speed, sprint_speed, strength)
		parent.acceleration = lerp(original_acceleration, sprint_acceleration, strength)
		parent.jump_impulse = lerp(original_jump, sprint_jump_impulse, strength)
		if Input.is_action_just_pressed("sprint"):
			audio.play()
	else:
		parent.top_speed = original_speed
		parent.acceleration = original_acceleration
		parent.jump_impulse = original_jump

func check_stamina(delta)->bool:
	var result:bool = stamina != null
	if result && !parent.target_direction.is_zero_approx():
		result = stamina.use(stamina_cost*delta*Input.get_action_strength("sprint")*parent.target_direction.length())
	return result
