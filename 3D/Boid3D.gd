extends Area3D

const MAX_SPEED = 1
const BOUNDARY_Y = 32
const BOUNDARY_X = 64
const BOUNDARY_Z = 64
const BOUNDARY_REPULSION = 0.1
var velocity = Vector3(randf_range(-MAX_SPEED, MAX_SPEED), randf_range(-MAX_SPEED, MAX_SPEED), randf_range(-MAX_SPEED, MAX_SPEED))
var local_boids = []
var perch_timer = 0
var recently_perched = false


func _process(delta):
	# perched
	if perch_timer >= 0:
		perch_timer -= 1
		return
	
	# should perch
	if position.y < -BOUNDARY_Y && !recently_perched && Rules.is_perching_enabled:
		perch_timer = randi_range(64, 256)
		# rotation = -1.5708
		recently_perched = true
		velocity.y = -velocity.y
		return
	
	
	# out of bounds - gently redirect into the viewport
	if position.x < -BOUNDARY_X:
		velocity.x += BOUNDARY_REPULSION
	elif position.x > BOUNDARY_X:
		velocity.x -= BOUNDARY_REPULSION
	if position.z > 0:
		velocity.z -= BOUNDARY_REPULSION
	elif position.z < -BOUNDARY_Z:
		velocity.z += BOUNDARY_REPULSION
	if position.y < -BOUNDARY_Y:
		velocity.y += BOUNDARY_REPULSION
	elif position.y > BOUNDARY_Y:
		velocity.y -= BOUNDARY_REPULSION
	else:
		recently_perched = false
	
		# alone - moving in the same direction
	if local_boids.size() == 0:
		position += velocity
		# rotation = velocity.normalized().angle()
		return
	
	# cohesion - gravitate towards other boids
	var cohesion = Vector3.ZERO
	if Rules.is_cohesion_enabled:
		for boid in local_boids:
			cohesion += boid.position
		cohesion /= local_boids.size()
		cohesion -= position
		cohesion /= 64
	
	# separation - don't collide with other boids
	var separation = Vector3.ZERO
	if Rules.is_separation_enabled:
		for boid in local_boids:
			if position.distance_to(boid.position) < 8:
				separation -= boid.position - position
	
	# alignment - steer to match direction with other boids
	var alignment = Vector3.ZERO
	if Rules.is_alignment_enabled:
		for boid in local_boids:
			alignment += boid.velocity
		alignment /= local_boids.size()
		alignment -= velocity
	
	velocity += (cohesion + separation + alignment) * delta
	
	# prevent boid from moving arbitrarily fast
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	velocity.z = clamp(velocity.z, -MAX_SPEED, MAX_SPEED)
	
	# update position and rotation
	position += velocity
	# rotation = velocity.normalized().angle()


func _on_boid_3d_area_entered(area):
	local_boids.append(area)


func _on_boid_3d_area_exited(area):
	local_boids.remove_at(local_boids.find(area))
