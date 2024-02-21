extends Decal

class_name KFPS_Decal

@export var decal_scale:float = 0.1

@export var lifetime:float = 3

@onready var camera = get_viewport().get_camera_3d()

var fademult = 0

@export var normal:Vector3

var light:OmniLight3D = OmniLight3D.new()

func _ready():
	add_child(light)
	light.shadow_enabled = false
	light.position = Vector3(0,.1,0)
	if texture_albedo == null:
		texture_albedo = load("res://icon.svg")
	size = Vector3.ONE*decal_scale
	var t = Timer.new()
	add_child(t)
	t.connect("timeout",switch)
	t.start(lifetime-1)
	sorting_offset = camera.decal_offset + size.length()*10
	camera.decal_offset += sorting_offset
	if normal != null && normal != Vector3():
		look_at(global_position+(normal*1000), camera.weird_up)
		var b = global_transform.basis
		global_transform.basis = Basis(b.x,b.z,b.y)
		rotate(normal, 2*PI*randf())

func _physics_process(delta):
	albedo_mix = lerpf(albedo_mix, 0, delta*fademult)
	light.light_energy = lerpf(light.light_energy, 0, delta*10.0)
	if albedo_mix <= 0.01:
		queue_free()

func switch():
	fademult = 1
