extends Area2D

var direction = 1
var EnemyMaxHp = 3
var EnemyHp
var DMG

func _ready() -> void:
	EnemyHp = EnemyMaxHp
	print(EnemyHp)
	DMG = 1
	add_to_group("player")


func _physics_process(delta: float) -> void:
	#print($RayCast2D2.target_position)
	platform_edge()
	position.x += 1 * direction
	
	if (EnemyHp > EnemyMaxHp):
		EnemyHp = EnemyMaxHp
	if (EnemyHp <= 0):
		queue_free()

func platform_edge():
	if not $RayCast2D.is_colliding():
		direction = -direction 
		$RayCast2D.position.x *= -1
		$RayCast2D2.target_position = Vector2((direction*9),0)
		
	if $RayCast2D2.is_colliding():
			direction = -direction 
			$RayCast2D.position.x *= -1
			$RayCast2D2.target_position = Vector2((direction*9),0)
			
	if $RayCast2D2.is_colliding():
		var obj = $RayCast2D2.get_collider()


func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group("weaponhitbox")):
		EnemyHp -= 1
		print(EnemyHp)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.Hurt(DMG)
	
