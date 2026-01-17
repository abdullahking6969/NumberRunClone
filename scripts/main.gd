extends Node3D

@export var camera_rig : Node3D
@export var player: RigidBody3D
@export var final_boss: Area3D
@export var fade : CanvasLayer

func _ready() -> void:
	fade.fade(0.0,1.0)

func _physics_process(_delta: float) -> void:
	camera_rig.position.z = player.position.z + 8
	if player.is_dead == true:
		var cam := get_viewport().get_camera_3d()
		if cam and cam.has_method("add_shake"):
			cam.add_shake(0.8)
	if is_instance_valid(final_boss) and final_boss.is_dead:
		var cam := get_viewport().get_camera_3d()
		if cam and cam.has_method("add_shake"):
			cam.add_shake(0.6)

func _on_restartbutton_pressed() -> void:
	get_tree().reload_current_scene()
