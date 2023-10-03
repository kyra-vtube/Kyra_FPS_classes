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
	var result = space.intersect_ray(param)
	if !result.is_empty():
		if result.collider.is_in_group("hurtbox"):
			result.collider.damage(damage,result.point)
