extends Node3D

var boid_scene = preload("res://3D/Boid3D.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		var boid = boid_scene.instantiate()
		add_child(boid)
		boid.position = Vector3.ZERO
