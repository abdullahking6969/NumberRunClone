extends Area3D

# Exported so you can change it per level
@export var boss_number: int = 2000

# Optional reference to your player node
@export var player_path: NodePath
var player
var is_dead := false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ui: CanvasLayer = $"../UI"
@onready var fade: CanvasLayer = $"../Fade"

func _ready():
	Engine.time_scale = 1
	if player_path != null:
		player = get_node(player_path)
	ui.hide()
	
	# Make mesh unique and show boss number
	if $MeshInstance3D.mesh:
		$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate()
		var text_mesh := $MeshInstance3D.mesh as TextMesh
		if text_mesh:
			text_mesh.text = str(boss_number)
	
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body == player:
		player.axis_lock_linear_x = true
		player.axis_lock_linear_y = true
		player.axis_lock_linear_z = true
		var player_number = player.current_number
		if player_number >= boss_number:
			if is_dead:
				return
			is_dead = true
			Engine.time_scale = 0.6
			_fake_smash($MeshInstance3D)
			$CollisionShape3D.disabled = true
			await get_tree().create_timer(0.4).timeout
			await fade.fade(1.0,1.0).finished
			get_tree().change_scene_to_file("res://scenes/Level1.tscn")
			queue_free()
		else:
			player.die()

func _fake_smash(mesh: Node3D):
	if not mesh:
		return

	# Detach so it doesn't fight parent transforms
	mesh.reparent(get_parent())

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
