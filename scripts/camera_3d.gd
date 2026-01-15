extends Camera3D

@export var shake_strength := 0.25
@export var shake_decay := 8.0

var trauma := 0.0
var shake_offset := Vector3.ZERO

func add_shake(amount: float):
	trauma = clamp(trauma + amount, 0.0, 1.0)

func _process(delta):
	if trauma > 0.0:
		trauma = max(0.0, trauma - shake_decay * delta)

		var s := trauma * shake_strength
		shake_offset = Vector3(
			randf_range(-s, s),
			randf_range(-s, s),
			0
		)
	else:
		shake_offset = Vector3.ZERO

	transform.origin = shake_offset
