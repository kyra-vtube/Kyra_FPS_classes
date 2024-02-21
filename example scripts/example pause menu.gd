extends Control

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

func _on_visibility_changed():
	if visible:
		$VBoxContainer.show()


func _on_resume_pressed():
	get_parent().hide()
	get_tree().paused = false


func _on_quit_pressed():
	get_tree().quit()


func _on_cancel_pressed():
	$VBoxContainer.show()
	$"quit menu".hide()


func _on__quit_pressed():
	$"quit menu".show()
	$VBoxContainer.hide()
	$"quit menu".move_to_front()

func death():
	$VBoxContainer.hide()
	$"quit menu".hide()
	$"death menu".show()
