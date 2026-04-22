extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.set_physics_process(false)
		animation_player.play("secret")
		await animation_player.animation_finished
		body.set_physics_process(true)
		queue_free()
