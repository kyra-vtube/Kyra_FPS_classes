extends Node3D

##NPCs use this to search for KFPS_NPCVisibilityPoints
class_name KFPS_NPCPerception

##How many times a second the list of visibility points is updated
@export var poll_rate:float = 6

@export var query_per_frame:int = 8

@export var priorities:PackedStringArray = ["player"]

@export var ignores:PackedStringArray = []

@export var parent:KFPS_Actor

var visible_points:Array[Node]

var visible_objects:Array[CollisionObject3D]

var timer:Timer = Timer.new()

var param:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()

var search_index:int = 0

func _ready():
	add_child(timer)
	timer.connect("timeout", query_points)
	timer.start( 1 / ( poll_rate * randf_range( 0.9,1.0 ) ))
	param.exclude = [parent]

func _physics_process(_delta):
	var space = PhysicsServer3D.space_get_direct_state(
		PhysicsServer3D.body_get_space(parent))
	param.from = global_position
	for v in range( search_index, clamp( search_index + query_per_frame, 0, visible_points.size() ) ):
		var i = visible_points[v]
		param.to = i.global_position
		var r = space.intersect_ray(param)
		if !r.is_empty():
			if r.collider == i.get_parent() && !visible_objects.has( i.get_parent() ):
				visible_objects.append( i.get_parent() )
	if search_index >= visible_points.size():
		visible_objects = []
		visible_points = []
	search_index = wrapi( search_index+query_per_frame,0,visible_objects.size() - 1 )

func query_points():
	var forward = -global_transform.basis.z.normalized()
	var list = get_tree().get_nodes_in_group("visible")
	visible_points = []
	if !priorities.is_empty():
		for i in list:
			for a in priorities:
				if i.tags.has(a):
					if global_position.direction_to(i.global_position).dot(forward) > 0.5:
						visible_points.append(i)
	else:
		visible_points = list
	timer.start( 1.0 / ( poll_rate * randf_range( 0.9, 1.0 ) ) )
