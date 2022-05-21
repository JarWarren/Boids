class_name Boid
extends Sprite2D

const MAX_SPEED = 3
var _velocity = Vector2(randi_range(-MAX_SPEED, MAX_SPEED), randi_range(-MAX_SPEED, MAX_SPEED))

func _process(_delta):
	_velocity += _align() + _separate() + _cohere()
	position += _velocity
	rotation = _velocity.normalized().angle()


func _align() -> Vector2:
	return Vector2.ZERO


func _separate() -> Vector2:
	return Vector2.ZERO


func _cohere() -> Vector2:
	return Vector2.ZERO
