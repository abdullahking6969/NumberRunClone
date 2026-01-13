extends Area3D

@export var value: int = 1              # number to apply
@export var number_type: String = "add" # "add", "subtract", "multiply"

func _ready():
	# Make mesh unique so each obstacle can have its own number
	if $MeshInstance3D.mesh:
		$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate()
		var text_mesh := $MeshInstance3D.mesh as TextMesh
		if text_mesh:
			match number_type:
				"add":
					text_mesh.text = "+" + str(value)
					$Sprite3D.modulate = Color(0,1,0) # green
				"subtract":
					text_mesh.text = "-" + str(value)
					$Sprite3D.modulate = Color(1,0,0) # red
				"multiply":
					text_mesh.text = "×" + str(value)
					$Sprite3D.modulate = Color(0,0,1) # blue

	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_number_change"):
		match number_type:
			"add":
				body.apply_number_change(value)
			"subtract":
				body.apply_number_change(-value)
			"multiply":
				body.apply_number_change(body.current_number * (value - 1)) # multiply
		# optional: destroy obstacle after hit
		queue_free()
