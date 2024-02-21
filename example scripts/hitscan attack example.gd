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
	param.collision_mask = KFPS_CollisonLayerClass.layers.damage# && KFPS_CollisonLayerClass.layers.terrain
	param.collide_with_areas = true
	var r = space.intersect_ray(param)
	var d = KFPS_HitData.new(damage)
	if !r.is_empty():
		decal.normal = r.normal
		d.normal = r.normal
		d.point = r.position
		d.direction = from.direction_to(to)
		if r.collider.has_method("damage"):
			r.collider.damage(d)
			var k = KFPS_NoiseEvent.new()
			r.collider.get_viewport().add_child(k)
			k.global_position = r.position
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
