extends Area2D

var PlayerLocked = false


func _physics_process(delta: float) -> void:
	if (PlayerLocked):
		EnemyCombat()

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		print("Found Player")
		PlayerLocked = true
		

func _on_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")):
		print("Lost Player")
		PlayerLocked = false

func EnemyCombat() -> void:
	pass
