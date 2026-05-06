extends Area2D

@export var current_scene : bool
@export var new_scene : bool



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		pass
