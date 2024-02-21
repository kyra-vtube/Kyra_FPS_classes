static var decal:Decal = KFPS_Decal.new()
static var particles = load("res://KFPS-classes/example scenes/Example particles.tscn")

static func do(from:Vector3, to:Vector3, damage:float, player:KFPS_Player):
	var space = PhysicsServer3D.space_get_direct_state(
		PhysicsServer3D.body_get_space(
			player
		)
	)
	var param:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	param.from = from
	param.to = to
	param.exclude = [player]
	param.collision_mask = KFPS_CollisonLayerClass.layers.damage
	param.collide_with_areas = true
	for i in 8:
		param.to += Vector3(player.camera.global_transform.basis.x.normalized()*randf_range(-600,600))+Vector3(
			player.camera.global_transform.basis.y.normalized()*randf_range(-600,600))
		var r = space.intersect_ray(param)
		if !r.is_empty():
			var d = KFPS_HitData.new(damage,r.position,r.normal,from.direction_to(to))
			whatever(r, d, from, to)

static func whatever(r, d, from, to):
	decal.normal = r.normal
	if r.collider.has_method("damage"):
		r.collider.damage(d)
		var new_dec = decal.duplicate()
		new_dec.normal = r.normal
		var new_part = particles.instantiate().duplicate()
		var new_noise = KFPS_HitSound.new()
		r.collider.add_child(new_dec)
		r.collider.add_child(new_part)
		new_dec.get_tree().get_root().add_child(new_noise)
		new_dec.global_position = r.position
		new_part.global_position = r.position
		new_noise.global_position = r.position
		var bounce = from.direction_to(to).bounce(r.normal)
		new_part.look_at(r.position+bounce)
