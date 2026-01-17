extends Control

@onready var texture_rect: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("boot")



func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	_anim_name = "boot"
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
