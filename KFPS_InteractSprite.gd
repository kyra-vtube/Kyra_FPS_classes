extends Sprite2D

class_name KFPS_InteractSprite

@export_dir var override_scene:String = ""

func _ready():
	if texture == null && override_scene == null:
		texture = load("res://icon.svg")
		scale/=2
	elif override_scene != "":
		var scene = load(override_scene)
		add_child(scene.instantiate())
	hide()
	position = get_window().size/2

func _process(_delta):
	pass
