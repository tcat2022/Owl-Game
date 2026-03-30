extends Area2D

var DMG = 1
var Enemydirection
var Knockback = Vector2(250, -200)
var EnemyMaxHp = 3
var EnemyHp
var PlayerDamage
var PlayerKnockback
var velocity

func _ready() -> void:
	EnemyHp = EnemyMaxHp #Sets enemy Health to max when game is loaded

func _physics_process(delta: float) -> void:
	Enemydirection = $"..".direction #Gets enemy's direction
	velocity = $"..".velocity #Gets enemy's velocity as a Vector2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #If enemy hitbox hits player hitbox
		if body.has_method("Hurt"): #Checks if player has a "Hurt" function
			body.Hurt(DMG, Knockback, Enemydirection) #If activates hurt function
			print("Ow")


func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if (area.is_in_group("weaponhitbox")): #Checks if enemy's hitbox collided with weapon
		PlayerDamage = area.PlayerDamage #Set Player Damage
		PlayerKnockback = area.PlayerKnockback #Set Player Knockback
		EnemyHealthSystem(EnemyMaxHp,EnemyHp,PlayerDamage, PlayerKnockback)
		#^^ Sends everything to Enemy health function
		print(EnemyHp)
		
		
func EnemyHealthSystem(MaxHealth:int, Health: int, PlayerDamage: int, 
PlayerKnockback: Vector2) -> void: #Enemy health Function
	EnemyHp = EnemyHp - PlayerDamage #Subtracts player damage from Enemy hp
	print(PlayerDamage)
	print(PlayerKnockback)
	
	
	if (EnemyHp > EnemyMaxHp): #If enemy hp is greater then max hp, sets it to max hp
		EnemyHp = EnemyMaxHp
		
	if (EnemyHp <= 0): #if enemy hp is less or equal to 0, he ded
		$"..".queue_free()
		
	
		
