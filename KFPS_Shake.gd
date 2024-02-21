extends Object

class_name KFPS_Shake

static func shake2D(intensity:float = 1.0):
	var x = randf_range(-intensity,intensity)
	var y = randf_range(-intensity,intensity)
	return Vector2(x,y)

static func shake3D(intensity:float = 1.0):
	var x = randf_range(-intensity,intensity)
	var y = randf_range(-intensity,intensity)
	var z = randf_range(-intensity,intensity)
	return Vector3(x,y,z)

