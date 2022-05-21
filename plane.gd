extends Node2D

var boid_scene = preload("res://Boid.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		var boid = boid_scene.instantiate()
		add_child(boid)
		boid.global_position = get_global_mouse_position()
	# make the 3 rules togglable with hotkeys
