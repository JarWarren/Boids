extends CanvasLayer

var scene_2d = preload("res://2D/Scene2D.tscn")
var scene_3d = preload("res://3D/Scene3D.tscn")

@onready var active_scene = $Scene2D
@onready var cohesion = $Cohesion
@onready var separation = $Separation
@onready var alignment = $Alignment
@onready var perching = $Perching
@onready var tabs: TabBar = $TabBar
@onready var hint_label = $HintLabel


func _process(_delta):
	if Input.is_action_just_pressed("cohesion"):
		Rules.is_cohesion_enabled = !Rules.is_cohesion_enabled
		cohesion.button_pressed = Rules.is_cohesion_enabled
	if Input.is_action_just_pressed("separation"):
		Rules.is_separation_enabled = !Rules.is_separation_enabled
		separation.button_pressed = Rules.is_separation_enabled
	if Input.is_action_just_pressed("alignment"):
		Rules.is_alignment_enabled = !Rules.is_alignment_enabled
		alignment.button_pressed = Rules.is_alignment_enabled
	if Input.is_action_just_pressed("perching"):
		Rules.is_perching_enabled = !Rules.is_perching_enabled
		perching.button_pressed = Rules.is_perching_enabled
	if Input.is_action_just_pressed("toggle"):
		tabs.current_tab = 1 - tabs.current_tab
	if Input.is_action_just_pressed("click"):
		hint_label.visible = false


func _on_tab_bar_tab_changed(tab):
	remove_child(active_scene)
	active_scene.call_deferred("free")
	match tab:
		0:
			active_scene = scene_2d.instantiate()
		1:
			active_scene = scene_3d.instantiate()
	add_child(active_scene)


func _on_perching_toggled(button_pressed):
	Rules.is_perching_enabled = button_pressed


func _on_alignment_toggled(button_pressed):
	Rules.is_alignment_enabled = button_pressed


func _on_separation_toggled(button_pressed):
	Rules.is_separation_enabled = button_pressed


func _on_cohesion_toggled(button_pressed):
	Rules.is_cohesion_enabled = button_pressed


func _on_cohesion_mouse_entered():
	hint_label.text = "Boids move towards each other"
	hint_label.visible = true


func _on_separation_mouse_entered():
	hint_label.text = "Boids avoid colliding with each other"
	hint_label.visible = true


func _on_alignment_mouse_entered():
	hint_label.text = "Boids try to steer in the same direction"
	hint_label.visible = true


func _on_perching_mouse_entered():
	hint_label.text = "Phew! Boids rest their feet."
	hint_label.visible = true


func _on_mouse_exited():
	hint_label.visible = false
