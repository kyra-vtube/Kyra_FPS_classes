extends RigidBody3D

class_name  KFPS_Rigidbody

@export var shoot_noise:AudioStream

@export var clank_noise:AudioStream

@export var scrape_noise:AudioStream

@export_dir var hit_effect = "res://KFPS-classes/example scenes/Example particles.tscn"

@export_dir var hit_decal = "res://KFPS-classes/example scenes/decal example.tscn"

@export var mesh:MeshInstance3D

@export var linear_clang_lower_threshhold:float = 5

@export var angular_clang_lower_threshhold:float = PI

@onready var world = get_tree().get_root()

var shoot_sound:KFPS_HitSound = KFPS_HitSound.new()

var clank_sound:KFPS_HitSound = KFPS_HitSound.new()

var fx

var hd

var old_linear_velocity:Vector3

var old_angular_velocity:Vector3

var touching:bool = false

var scraping:bool = false

var scrape_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()

var scrape_position:float

@onready var camera = get_viewport().get_camera_3d()

func _ready():
	add_to_group("hurtbox")
	shoot_sound.stream = shoot_noise
	clank_sound.stream = clank_noise
	clank_sound.doppler_tracking = AudioStreamPlayer3D.DOPPLER_TRACKING_PHYSICS_STEP
	fx = load(hit_effect).instantiate()
	hd = load(hit_decal).instantiate()
	connect("body_entered",touch)
	connect("body_exited",untouch)
	add_child(scrape_player)
	scrape_player.stream = scrape_noise
	camera =  get_viewport().get_camera_3d()

func damage(amount, point:Vector3, normal:Vector3 = Vector3.UP, _shape:int = 0):
	apply_impulse(normal*(amount/mass), to_local(point))
	var sd = shoot_sound.duplicate()
	var fxd = fx.duplicate()
	var hdd = hd.duplicate()
	world.add_child(sd)
	add_child(fxd)
	mesh.add_child(hdd)
	sd.global_position = point
	fxd.global_position = point
	hdd.global_position = point
	hdd.look_at(normal+point, camera.weird_up)
	var b = hdd.global_transform.basis
	hdd.global_transform.basis = Basis(b.x,b.z,b.y)
	hdd.rotate(normal, 2*PI*randf())
	fxd.look_at(point-normal, camera.weird_up)

func _physics_process(_delta):
	detect_clank()
	detect_drag()
	manage_velocities()

func touch(_body):
	touching = true

func untouch(_body):
	touching = false

func detect_clank():
	if (old_angular_velocity - angular_velocity ).length() > angular_clang_lower_threshhold || (
		old_linear_velocity - linear_velocity ).length() > linear_clang_lower_threshhold:
		add_child(clank_sound.duplicate())

func detect_drag():
	var space = PhysicsServer3D.space_get_direct_state(
		PhysicsServer3D.body_get_space(self))
	var param:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	param.from = global_position
	param.to = global_position + old_linear_velocity * mesh.mesh.get_aabb().size.length()*PI
	param.exclude = [self]
	var r = space.intersect_ray(param)
	if !r.is_empty():
		var scrape_score = -r.normal.cross(
			linear_velocity.normalized()).dot(
				angular_velocity.normalized())
		scraping = scrape_score > 0
	if scraping:
		scrape_player.play()
	else:
		scrape_player.stop()

func manage_velocities():
	old_angular_velocity = angular_velocity
	old_linear_velocity = linear_velocity
