#By Kyra Gordon as part of KFPS

extends Camera3D

class_name KFPS_PlayerCamera

@export var use_mouselook:bool = true

@export var use_sticklook:bool = true

@export var use_gyrolook:bool = false

@export var mouse_vector:Vector2

@export var stick_vector:Vector2

@export var gyro_vector:Vector2

@export var mouse_sensitivity:float = 0.5

@export var stick_sensitivity:float = 1.0

@export var gyro_sensitivity:float = 0.1

@export var max_gun_slots:int = 4

var active_gun = 0

var belt:Node3D = Node3D.new()

var ray:RayCast3D = RayCast3D.new()

var decal_offset:float

var weird_up:Vector3 = (Vector3.UP+Vector3.RIGHT).normalized()

var interact_sprite:KFPS_InteractSprite = KFPS_InteractSprite.new()

var juice:KFPS_CameraJuicer = KFPS_CameraJuicer.new()

func _ready():
	position.y = get_parent().height/4.5
	for i in [belt,ray,interact_sprite,juice]:
		add_child(i)
	ray.add_exception(get_parent())
	ray.enabled = true
	ray.target_position = Vector3(0,0,-25)
	ray.collision_mask = KFPS_CollisonLayerClass.layers["interactive"]
	for i in 17:
		set_cull_mask_value(i+3,false)
	make_current()

##The _input function is used to collect the relative mouse movement
func _input(event):
	if event is InputEventMouseMotion:
		mouse_vector = -event.relative * mouse_sensitivity * float(use_mouselook)

##The player camera is rotated every frame to keep the motion looking as smooth as possible
func _process(delta):
	control_look(delta)
	if ray.is_colliding():
		var col = ray.get_collider()
		if col.has_method("interact"):
			interact_sprite.show()
			if Input.is_action_just_pressed("interact"):
				col.interact(get_parent())
				interact_sprite.hide()
		else:
			interact_sprite.hide()
	var gun_binds = ["gun 1","gun 2","gun 3","gun 4"]
	for i in belt.get_child_count():
		if Input.is_action_just_pressed(gun_binds[i]):
			select_gun(i)
	if get_guns().size() > 0:
		select_gun(
				active_gun + int(Input.is_action_just_pressed("next weapon")
				) - int(Input.is_action_just_pressed("previous weapon")
			)
		)

##control_look combines data from the joypad, gyroscope and mouse to rotate the camera and the player node
func control_look(delta):
	var final_vector:Vector2 = mouse_vector + get_stick_vector() + get_gyro_vector()
	mouse_vector = Vector2()
	rotate_x(final_vector.y * delta)
	rotation.x = clamp( rotation.x, -1.5, 1.5 )
	get_parent().rotate_y(final_vector.x * delta)

##Returns the vector of the joypad inputs bound to "look down", "look up", "look left" and "look right"
func get_stick_vector()->Vector2:
	return Input.get_vector("look right", "look left", "look down", "look up") * stick_sensitivity * float(use_sticklook)

##Returns the vector reported by the gyroscope
func get_gyro_vector()->Vector2:
	var g = Input.get_gyroscope()*gyro_sensitivity
	return Vector2(g.x,g.y) * gyro_sensitivity * float(use_gyrolook)

##Called when a gun or similar item is picked up
func add_gun(gun:KFPS_Gun):
	var success:bool = belt.get_child_count() < max_gun_slots
	if success:
		belt.add_child(gun)
		gun.wielder = get_parent()
		select_last_gun()
	return success

func get_guns():
	return belt.get_children()

func gun_count():
	return get_guns().size()

func get_active_gun():
	if !get_guns().is_empty():
		return get_guns()[active_gun]

##Selects the item in the weapon list at the given index
func select_gun(index:int):
	var guns_size = gun_count()
	active_gun = wrapi(index,0,guns_size)
	show_active_gun()

##Removes the item at the given index
func discard_tool():
	get_active_gun().discard()

func show_active_gun():
	for i in get_guns():
		i.hide()
	get_active_gun().show()

func select_last_gun():
	select_gun(gun_count()-1)
