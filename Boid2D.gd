extends Area2D

const MAX_SPEED = 3
var velocity = Vector2(randf_range(-MAX_SPEED, MAX_SPEED), randf_range(-MAX_SPEED, MAX_SPEED))
var local_boids = []

func _ready():
	rotation = velocity.normalized().angle()

func _process(_delta):
	if local_boids.size() == 0:
		position += velocity
		return
	var cohesion = Vector2.ZERO
	var separation = Vector2.ZERO
	var alignment = Vector2.ZERO
	for boid in local_boids:
		cohesion += boid.position
		alignment += boid.velocity
		if position.distance_to(boid.position) < 32:
			separation -= boid.position - position
	cohesion /= local_boids.size()
	cohesion -= position
	cohesion /= 128
	alignment /= local_boids.size()
	alignment -= velocity
	alignment /= 32
	velocity += cohesion + separation + alignment
	if position.x < 0:
		velocity.x += 1
	elif position.x > 1024:
		velocity.x -= 1
	if position.y < 0:
		velocity.y += 1
	elif position.y > 600:
		velocity.y -= 1
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	position += velocity
	rotation = velocity.normalized().angle()


func _on_boid_2d_area_entered(area):
	local_boids.append(area)


func _on_boid_2d_area_exited(area):
	local_boids.remove_at(local_boids.find(area))
