extends Area3D

@export var value: int = 1  # number this coin gives

func _ready():
	# Make mesh unique so each coin can have its own number
	if $MeshInstance3D.mesh:
		$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate()
		var text_mesh_instance := $MeshInstance3D.mesh as TextMesh
		if text_mesh_instance:
			text_mesh_instance.text = str(value)

	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_number_change"):
		body.apply_number_change(value)
		queue_free()
