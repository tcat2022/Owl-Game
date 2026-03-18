extends Area2D
var DMG = 1
var Enemydirection
var Knockback = Vector2(250, -200)
var EnemyMaxHp = 3
var EnemyHp
var PlayerDamage
var PlayerKnockback
var velocity
var PlayerDirection
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	EnemyHp = EnemyMaxHp

func _physics_process(delta: float) -> void:
	Enemydirection = $"..".direction
	velocity = $"..".velocity

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("Hurt"):
			body.Hurt(DMG, Knockback, Enemydirection)
			print("Ow")


func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if (area.is_in_group("weaponhitbox")):
		PlayerDamage = area.PlayerDamage
		PlayerKnockback = area.PlayerKnockback
		PlayerDirection = area.Playerdirection
		EnemyHealthSystem(EnemyMaxHp,EnemyHp,PlayerDamage, PlayerKnockback, PlayerDirection)
		
		print(EnemyHp)
		
		
func EnemyHealthSystem(MaxHealth:int, Health: int, PlayerDamage: int, 
PlayerKnockback: Vector2, PlayerDirection: int) -> void:
	EnemyHp = EnemyHp - PlayerDamage
	print(PlayerDamage)
	print(PlayerKnockback)
	
	
	if (EnemyHp > EnemyMaxHp):
		EnemyHp = EnemyMaxHp
		
	if (EnemyHp <= 0):
		$"..".queue_free()
		
	
		
