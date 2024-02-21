extends Node3D

class_name KFPS_Gun

##Represents if the tool is being thrown away
#var discarding:bool = false

##Gun's damage
@export var damage:float = 10.0

##Gun's rate of fire
@export var ROF:float = 10.0

##Defines the ammo type the gun uses
@export var ammo_name:String = "10mm"

#Action string for firing this gun
@export var fire_action_bind:String = "fire gun primary"

@export var discard_action_bind:String = "discard gun"

##Scene to load to represent the discarded weapon
@export_file(".tscn") var discard_scene_path:String = "res://KFPS-classes/example scenes/test gun pickup scene.tscn"

@export var shot_sound:AudioStream

@export var empty_sound:AudioStream

@export var mag_capacity:int = 10

@export var max_range:float = 9999

@export_file(".gd") var fire_script:String = "res://KFPS-classes/example scripts/hitscan attack example.gd"

var mag = 10

var audioPlayer:AudioStreamPlayer3D = AudioStreamPlayer3D.new()

@export var animator:AnimationPlayer

var disc_scene

var _script

##Keeps track of whether the primary function of the weapon is ready for use
var is_ready:bool = true

@export var loaded:bool = true

var timer:Timer = Timer.new()

##Who holds the tool
var wielder:KFPS_Actor

@export var automatic = false

func _ready():
	disc_scene = load(discard_scene_path).instantiate()
	for i in [timer, audioPlayer]:
		add_child(i)
	timer.connect("timeout",manage_cycle)
	ROF = 1.0/ROF # we do this so we're not doing it every time the gun is fired
	_script = load(fire_script)

func _process(_delta):
	if Input.is_action_just_pressed("reload") && mag < mag_capacity && wielder.ammobelt.get_quantity(ammo_name) > 0:
		animator.play("reload")
#	if Input.is_action_pressed(discard_action_bind):
#		discard()
	elif is_ready && visible && (
			Input.is_action_just_pressed(fire_action_bind) && !automatic ||
			Input.is_action_pressed(fire_action_bind) && automatic):
		if mag > 0:
			fire()
		else:
			audio_play(empty_sound)

#Executes a script that handles the gun's attack behaviour. By default, a hitscan
func fire():
	mag-=1
	is_ready = false
	timer.start(ROF)
	audio_play(shot_sound)
	animator.play("fire")
	_script.do(global_position, global_position-global_transform.basis.z*max_range, damage, wielder)

###Change this to modify a gun's discard behaviour
#func discard():
#	if visible:
#		get_tree().get_root().add_child(disc_scene)
#		disc_scene.global_transform = global_transform
#		var offset_pos = (-wielder.global_transform.basis.z.normalized(
#			)+wielder.global_transform.basis.x.normalized(
#			)-wielder.global_transform.basis.y.normalized())/5
#		disc_scene.position += offset_pos
#		wielder = null
#		queue_free()

##Readies the gun after it's use delay
func manage_cycle():
	is_ready = true

func reload():
	mag += wielder.ammobelt.request_ammo(ammo_name, mag_capacity-mag)
	loaded = true

func audio_play(stream):
	audioPlayer.stream = stream
	audioPlayer.play()
