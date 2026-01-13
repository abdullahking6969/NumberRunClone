extends Area3D

# Exported so you can change it per level
@export var boss_number: int = 2000

# Optional reference to your player node
@export var player_path: NodePath
var player

func _ready():
	if player_path != null:
		player = get_node(player_path)
	
	# Make mesh unique and show boss number
	if $MeshInstance3D.mesh:
		$MeshInstance3D.mesh = $MeshInstance3D.mesh.duplicate()
		var text_mesh := $MeshInstance3D.mesh as TextMesh
		if text_mesh:
			text_mesh.text = str(boss_number)
	
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body == player:
		# Access the variable directly
		var player_number = player.current_number
		if player_number >= boss_number:
			print("YOU WIN THE LEVEL!")
			queue_free()
		
		else:
			print("YOU LOSE THE LEVEL!")
			get_tree().reload_current_scene()
			# trigger fail sequence here
