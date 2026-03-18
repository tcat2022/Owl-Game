extends CharacterBody2D

var direction = 1
var EnemyMaxHp = 3
var EnemyHp
const Gravity = 900
var obj
var DetectionXPosition
var PlayerDirection
var PlayerKnockback
var xKnockback = Vector2.ZERO
func _ready() -> void:
	EnemyHp = EnemyMaxHp
	print(EnemyHp)


func _physics_process(delta: float) -> void:
	#print($RayCast2D2.target_position)
	platform_edge()
	velocity.x = 2000 * delta * direction + xKnockback.x
	
	if not is_on_floor():
		velocity.y += Gravity * delta
	xKnockback = lerp(xKnockback, Vector2.ZERO, 0.1)
	move_and_slide()
	
	
	
func platform_edge():
	
	if (direction < 0) && is_on_floor():
		$AnimatedSprite2D.flip_h = true
	elif (direction > 0) && is_on_floor():
		$AnimatedSprite2D.flip_h = false
	
	if not ($RayCast2D.is_colliding()):
		direction = -direction 
		$RayCast2D.position.x = -1
		$RayCast2D2.target_position = Vector2(13,0)
		
	if $RayCast2D2.is_colliding():
		direction = -direction 
		$RayCast2D.position.x *= -1
		$RayCast2D2.target_position = Vector2((direction*13),0)
			
	if $RayCast2D2.is_colliding():
		obj = $RayCast2D2.get_collider().name
	
func EnemyKnockBack(PlayerKnockback: Vector2, PlayerDirection: int) -> void:
	velocity.y += PlayerKnockback.y
	if (get_local_mouse_position().x >= 0):
		PlayerDirection = 1
	elif(get_local_mouse_position().x < 0):
		PlayerDirection = -1
	xKnockback.x = PlayerKnockback.x * PlayerDirection
