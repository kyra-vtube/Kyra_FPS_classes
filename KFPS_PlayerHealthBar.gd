extends Control

class_name KFPS_PlayerHealthBar

@export_dir var override_scene

var bar:ProgressBar = ProgressBar.new()

var health:KFPS_Health

func _ready():
	if override_scene == null:
		add_child(bar)
		bar.show_percentage = false
		bar.max_value = 1.0
		bar.min_value = 0.0
		bar.step = 0.01
		bar.set_anchors_preset(Control.PRESET_TOP_LEFT)
		bar.custom_minimum_size.x = 100
		bar.custom_minimum_size.y = 50
	else:
		add_child( load(override_scene).instantiate() )
	health = get_parent()
#	bar.connect("changed",change_bar)

func _physics_process(_delta):
	bar.value = health.get_health_percent()
