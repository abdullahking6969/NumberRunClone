extends RigidBody3D

const FORWARD_SPEED := 20.0
const SIDE_SPEED := 25.0

var dragging := false
var last_touch_x := 0.0

func _ready() -> void:
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	axis_lock_angular_z = true

func _physics_process(_delta: float) -> void:
	# Constant forward movement
	apply_central_force(Vector3(0, 0, -FORWARD_SPEED))

	# Stop side movement when not dragging
	if not dragging:
		linear_velocity.x = 0

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			last_touch_x = event.position.x
		else:
			dragging = false
			linear_velocity.x = 0   # hard stop on release

	if event is InputEventScreenDrag and dragging:
		var delta_x = event.position.x - last_touch_x
		last_touch_x = event.position.x

		linear_velocity.x = delta_x * 0.1 * SIDE_SPEED
