extends CharacterBody2D
var direction = 1
var EnemyMaxHp = 3
var EnemyHp
const Gravity = 900
var obj
var DetectionXPosition
var PlayerDirection
var PlayerKnockback
var EnemySpeed = 2000.0
var xKnockback = Vector2.ZERO
var isAttacking = false	
var canAttack = true
var xAttack = Vector2.ZERO
func _ready() -> void:
	EnemyHp = EnemyMaxHp
	print(EnemyHp)


func _physics_process(delta: float) -> void:
	platform_edge() #Go to platform Function
	velocity.x = EnemySpeed * delta * direction + xKnockback.x + xAttack.x #Determines Enemy Velocity
	#xKnockback determines enemy knockback
	#xAttack determines enemy "dash"
	
	if not is_on_floor():
		velocity.y += Gravity * delta #Enemy Gravity
	
	
	xKnockback = lerp(xKnockback, Vector2.ZERO, 0.1) #Slowly sets Enemy Knockback to 0
	xAttack = lerp(xAttack, Vector2.ZERO, 0.1) #Slowly sets Enemy "Dash" to 0

	move_and_slide() #Allows enemy to move
	
	if ($DetectionHitbox.PlayerLocked == true): #Enables Enemy Combat when in detection range
		EnemyCombat()
	else:
		EnemySpeed = 2000.0 #If not in combat, set enemy speed to default
	
	
	
func platform_edge():
	
	if (direction < 0) && is_on_floor():
		$AnimatedSprite2D.flip_h = true
	elif (direction > 0) && is_on_floor():
		$AnimatedSprite2D.flip_h = false
	
	if (!$RayCast2D.is_colliding() && is_on_floor()):
		direction = -direction 
		$RayCast2D.position.x = -1
		$RayCast2D2.target_position = Vector2(13,0)
		
	if $RayCast2D2.is_colliding():
		direction = -direction 
		$RayCast2D.position.x *= -1
		$RayCast2D2.target_position = Vector2((direction*13),0)
			
	if $RayCast2D2.is_colliding():
		obj = $RayCast2D2.get_collider().name
	
func EnemyKnockBack(PlayerKnockback: Vector2) -> void: #Function for Enemy Knockbackk
	velocity.y += PlayerKnockback.y #Adds knockback from player vertically
	if (get_local_mouse_position().x >= 0): #Checks mouse position
		PlayerDirection = 1 #If on right side, knocks enemy back to the right
	elif(get_local_mouse_position().x < 0):
		PlayerDirection = -1 #If on left side, knocks enemy back to the left
	xKnockback.x = PlayerKnockback.x * PlayerDirection #Sets how much knockback enemy recieves

func EnemyCombat(): #Enemy Combat Function
	if (!isAttacking): #Only Activates if Enemy is not Attacking
		if (canAttack): #Activates if Enemy can attack
			print("Attacking")
			isAttacking = true #Sets Attacking to true
			canAttack = false #Makes sure enemy Can't attack again
			if $AttackTimer.is_stopped(): #Checks if timer is not active
				EnemySpeed = 0 #If Timer is not active, "pause" the enemy
				$AttackTimer.start(1) #Start attack in 1 second
		elif (EnemySpeed > 1500 or EnemySpeed == 0): #Sets enemy to Combat speed when not attacking
			EnemySpeed = 1500 #Combat speed
			if $Timer.is_stopped(): #If Timer is not active, flips velocity
				$Timer.start(1) #Flips velocity in 1 second
				print("Timer")
	


func _on_timer_timeout() -> void: #Cooldown for velocity well in Combat
	EnemySpeed = EnemySpeed * -1 #Whenever Timer runs out, flips enemy velocity


func _on_attack_timer_timeout() -> void: #Attack charge time
	if (direction > 0): #If facing right side, attacks right
		xAttack.x = 750 #How far enemy dashes
		velocity.y += -100 #How far enemy "jumps" during dash
	elif (direction < 0): #If facing right left, attacks left
		xAttack.x = -750
		velocity.y += -100
	if $AttackCooldown.is_stopped(): #Checks to make sure Attack cooldown timer is off
		$AttackCooldown.start(3) #Starts Cooldown timer
	isAttacking = false #Makes sure enemy can not attack unless cooldown is down.
	print("ATTACK!!!") #ATTACK!!!!!!!


func _on_attack_cooldown_timeout() -> void:  #Determines cooldown
	canAttack = true #Makes enemy able to attack after cooldown is down.
