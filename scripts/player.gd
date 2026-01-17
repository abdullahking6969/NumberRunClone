extends RigidBody3D

@export var forward_speed := 15.0

@export var side_speed := 30.0
@export var acceleration := 12.0

@export var min_x := -4.0
@export var max_x := 4.0
@export var boundary_force := 40.0  # soft push back

@export var drag_sensitivity := 0.015
@export var text_mesh: MeshInstance3D
@export var coin_sfx: AudioStreamPlayer

var current_number: int = 1
var dragging := false
var last_touch_x := 0.0
var target_x_velocity := 0.0
var is_dead := false

@onready var ui: CanvasLayer = $"../UI"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_ui: CanvasLayer = $PlayerUI

func _ready() -> void:
	get_tree().paused = true
	player_ui.show()
	animation_player.play("click")
	Engine.time_scale = 1.0
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true
	ui.hide()
	if text_mesh and text_mesh.mesh:
		var text_mesh_instance := text_mesh.mesh as TextMesh
		if text_mesh_instance:
			text_mesh_instance.text = "1"

func _physics_process(delta: float) -> void:
	# ----- Forward movement -----
	apply_central_force(Vector3(0, 0, -forward_speed))

	# ----- Smooth acceleration -----
	linear_velocity.x = lerp(linear_velocity.x, target_x_velocity, acceleration * delta)

	# ----- Hard boundary guard (guaranteed no falling) -----
	if global_position.x <= min_x:
		linear_velocity.x = max(0, linear_velocity.x)
		target_x_velocity = max(0, target_x_velocity)
	elif global_position.x >= max_x:
		linear_velocity.x = min(0, linear_velocity.x)
		target_x_velocity = min(0, target_x_velocity)

	# ----- Soft boundary feel (for polish) -----
	if global_position.x < min_x:
		apply_central_force(Vector3(boundary_force, 0, 0))
	elif global_position.x > max_x:
		apply_central_force(Vector3(-boundary_force, 0, 0))

	# ----- Clamp position as final safety net -----
	var pos := global_position
	pos.x = clamp(pos.x, min_x, max_x)
	global_position = pos

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			last_touch_x = event.position.x
		else:
			dragging = false
			target_x_velocity = 0

	if event is InputEventScreenDrag and dragging:
		var delta_x: float = event.position.x - last_touch_x
		last_touch_x = event.position.x

		target_x_velocity = delta_x * drag_sensitivity * side_speed

func apply_number_change(value: int):
	current_number += value
	_update_text_mesh()
	coin_sfx.playing = true

func _update_text_mesh():
	if text_mesh and text_mesh.mesh:
		var text_mesh_instance := text_mesh.mesh as TextMesh
		if text_mesh_instance:
			text_mesh_instance.text = str(current_number)

func die():
	if is_dead:
		return
	is_dead = true

	# Stop movement
	freeze = true
	linear_velocity = Vector3.ZERO

	# Disable collision
	$CollisionShape3D.disabled = true

	# Fake smash animation
	_fake_smash()
	Engine.time_scale = 0.8
	await get_tree().create_timer(0.4).timeout
	ui.show()

func _fake_smash():
	var mesh := $MeshInstance3D
	if not mesh:
		return

	# Detach mesh so it doesn't fight player physics
	mesh.reparent(get_parent())

	# Random spin + fall
	var tween := get_tree().create_tween()
	tween.tween_property(mesh, "scale", Vector3.ZERO, 0.35)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		mesh,
		"rotation",
		mesh.rotation + Vector3(
			randf_range(-2, 2),
			randf_range(-2, 2),
			randf_range(-2, 2)
		),
		0.35
	)

	tween.tween_callback(mesh.queue_free)

func _on_button_pressed() -> void:
	get_tree().paused = false
	animation_player.stop()
	player_ui.hide()
