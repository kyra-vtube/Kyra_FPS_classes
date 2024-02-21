extends Control

class_name KFPS_Pause

@export_dir var menu_scene = "res://KFPS-classes/example scenes/example pause menu.tscn"

func _ready():
	add_child( load(menu_scene).instantiate() )
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	anchors_preset = PRESET_FULL_RECT
	add_to_group("pause")

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _process(_delta):
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
		move_to_front()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		hide()

func death():
	print("ye")
	get_tree().paused = true
	get_child(0).death()
