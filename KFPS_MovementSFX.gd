extends AudioStreamPlayer

class_name KFPS_MovementSFX

var parent:KFPS_Player

@export var skid_sound:AudioStream

@export var step_sounds:Array[AudioStream]

@export var jump_sound:AudioStream

@export var crash_sound:AudioStream

@export var tap_sound:AudioStream

@export var steps_per_meter:Curve

@export var sprint:KFPS_Sprint

var gait:float = 0

var step_progress:float

var skidding:float = false

var skid_player:AudioStreamPlayer = AudioStreamPlayer.new()

var crash_player:AudioStreamPlayer = AudioStreamPlayer.new()

var jump_player:AudioStreamPlayer = AudioStreamPlayer.new()

var tap_player:AudioStreamPlayer = AudioStreamPlayer.new()

var last_speed:float

var was_touching_floor:bool = true

var was_touching_wall:bool = true

var was_touching_ceiling:bool = true

func _ready():
	parent = get_parent()
	add_child(skid_player)
	add_child(crash_player)
	add_child(jump_player)
	add_child(tap_player)
	skid_player.stream = skid_sound
	crash_player.stream = crash_sound
	jump_player.stream = jump_sound
	tap_player.stream = tap_sound
	parent.connect("on_jump",jump)

func _physics_process(delta):
	steps(delta)
	skid()
	crash()

func steps(delta):
	var current_SPM = steps_per_meter.sample(parent.velocity.length()/parent.top_speed)
	step_progress += (parent.velocity.length()*delta)/current_SPM
	gait = clampf(gait+step_progress,0,1.0)
	if gait >= randf_range(0.9,1.0) && parent.is_on_floor() && !playing && !parent.velocity.is_zero_approx() && !parent.target_direction.is_zero_approx():
		stream = step_sounds[0]
		play()
		gait = 0
		step_sounds.shuffle()

func skid():
	skidding = parent.velocity.normalized().dot(-parent.target_direction)
	if !parent.get_wall_normal().is_zero_approx() && parent.velocity.length() > 0.1 && parent.is_on_wall():
		skidding += 1.0-abs(parent.get_wall_normal().dot(parent.velocity.normalized()))
	if ( parent.is_on_floor() || parent.is_on_wall() ) && skidding >= 0 && !parent.velocity.is_zero_approx():
		if !skid_player.playing:
			skid_player.play()
			skidding = 0
	else:
		skid_player.stop()
	var amount = (parent.velocity.length()/parent.top_speed)*10
	skid_player.volume_db = -10 + amount

func crash():
	var crash_stop = last_speed - parent.velocity.length() > parent.shape.crouch_speed
	if get_new_touch() || crash_stop:
		tap_player.play()
#			crash_player.play()
	last_speed = parent.velocity.length()
	was_touching_ceiling = parent.is_on_ceiling()
	was_touching_floor = parent.is_on_floor()
	was_touching_wall = parent.is_on_wall()

func jump():
	jump_player.play()

func get_new_touch():
	return ( !was_touching_ceiling && parent.is_on_ceiling()
		) || ( !was_touching_floor && parent.is_on_floor()
		) || ( !was_touching_wall && parent.is_on_wall() )
