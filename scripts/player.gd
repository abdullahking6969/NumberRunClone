extends RigidBody3D

const SPEED : int = 20

func _ready() -> void:
	self.axis_lock_angular_x = true
	self.axis_lock_angular_z = true
	self.axis_lock_angular_y = true

func _physics_process(_delta: float) -> void:
	self.apply_central_force(Vector3(0,0,-SPEED))
