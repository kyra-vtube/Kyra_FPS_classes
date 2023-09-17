extends Control

class_name KFPS_Pause

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(_delta):
	visible = get_tree().paused
