extends Area2D

const MAX_SPEED = 3
const BOUNDARY_REPULSION = 0.05
var velocity = Vector2(randf_range(-MAX_SPEED, MAX_SPEED), randf_range(-MAX_SPEED, MAX_SPEED))
var local_boids = []
var perch_timer = 0
var recently_perched = false


func _process(delta):
	# perched
	if perch_timer >= 0:
		perch_timer -= 1
		return
	
	# should perch
	if position.y > 596 && !recently_perched && Rules.is_perching_enabled:
		perch_timer = randi_range(64, 256)
		rotation = -1.5708
		recently_perched = true
		velocity.y = -velocity.y
		return
	
	# alone - moving in the same direction
	if local_boids.size() == 0:
		position += velocity
		rotation = velocity.normalized().angle()
		return
	
	
	# out of bounds - gently redirect into the viewport
	if position.x < 50:
		velocity.x += BOUNDARY_REPULSION
	elif position.x > 974:
		velocity.x -= BOUNDARY_REPULSION
	if position.y < 50:
		velocity.y += BOUNDARY_REPULSION
	elif position.y > 550:
		velocity.y -= BOUNDARY_REPULSION
	else:
		recently_perched = false
	
	# cohesion - gravitate towards other boids
	var cohesion = Vector2.ZERO
	if Rules.is_cohesion_enabled:
		for boid in local_boids:
			cohesion += boid.position
		cohesion /= local_boids.size()
		cohesion -= position
		cohesion /= 128
	
	# separation - don't collide with other boids
	var separation = Vector2.ZERO
	if Rules.is_separation_enabled:
		for boid in local_boids:
			if position.distance_to(boid.position) < 16:
				separation -= boid.position - position
	
	# alignment - steer to match direction with other boids
	var alignment = Vector2.ZERO
	if Rules.is_alignment_enabled:
		for boid in local_boids:
			alignment += boid.velocity
		alignment /= local_boids.size()
		alignment -= velocity
	
	velocity += (cohesion + separation + alignment) * delta
	
	# prevent boid from moving arbitrarily fast
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	# update position and rotation
	position += velocity
	rotation = velocity.normalized().angle()


func _on_boid_2d_area_entered(area):
	local_boids.append(area)


func _on_boid_2d_area_exited(area):
	local_boids.remove_at(local_boids.find(area))
