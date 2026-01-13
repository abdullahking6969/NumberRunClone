extends Node3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var player: RigidBody3D = $Player

func _physics_process(_delta: float) -> void:
	camera_3d.position.z = player.position.z + 6
