extends CharacterBody2D
@onready var node_2d: Area2D = $"../Node2D"
@onready var node_2d_2: Area2D = $"../Node2D2"
@onready var timer: Timer = $Timer
var proj_path = preload("res://Scenes/throw_spear_hit_box.tscn")
var spear
var hit_checkpoint = false
var test := 0
var mask_picked_up = false
var doubleJump = 1
var double = true
var Gravity = 900
const SPEED = 175.0
const FRICTION = 1000
const JUMP_VELOCITY = -250.0
var Xviewport
var Yviewport
var LocalXmouseposition
var Globalmouseposition
var Scalartesting = 0.0
var isAttacking = false	
const PhaseBasicAttack = 0
const PhaseAirAttack = 1
const PhaseSpecialAttack = 2
var SpecialButtonHeld = false
var CombatPhase
var Chargetimer = 0.0
var SpecialAvaliable = true
var direction
var Health
var MaxHealth = 10

@onready var player_sprite: AnimatedSprite2D = $Sprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $WeaponHitBox/AnimatedSprite2D

func _ready() -> void:
	Health = MaxHealth
	Globals.WeaponEquipped = false
	$WeaponHitBox.visible = false
	Globals.PlayerDamage = Vector2(150,-100)
	
	
func _physics_process(delta: float) -> void:
	
	Xviewport = float (get_viewport().size.x)
	LocalXmouseposition = get_local_mouse_position().x
	Globalmouseposition = get_global_mouse_position()
	Yviewport = float (get_viewport().size.y)
	
	
	
	if Input.is_action_just_pressed("pick up") and Globals.can_pick_up:
		node_2d.queue_free()
		mask_picked_up = true
		
	if Input.is_action_just_pressed("pick up") and Globals.can_pick_up_spear:
		node_2d_2.queue_free()
		mask_picked_up = true
		Globals.SpearObtained = true
		

	if is_on_floor():
		doubleJump = 0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += Gravity * delta


	# Handle jump.
	if Input.is_action_just_pressed("jump") and doubleJump != 2:
		doubleJump += 1
		velocity.y = JUMP_VELOCITY
		player_sprite.play("idle")
	
	#Gliding - Ze
	if (velocity.y > 0) && (Input.is_action_pressed("jump")): #Checks for hold jump and falling
		#print("ON!") #Check if statement is working
		Gravity = 100
	else:
		Gravity = 900

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction:
		player_sprite.play("walking")
		if direction == -1:
			player_sprite.flip_h = true
		else:
			player_sprite.flip_h = false
		
		velocity.x = move_toward(velocity.x, SPEED * direction, FRICTION * delta)
		
	else:
		player_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	position.x += test
	move_and_slide()
	
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
			
#==================================================================#
#Combat System:
	EquipingWeapon()
	
	#print(CombatPhase)
	#print(SpecialAvaliable)
	
	if (Globals.WeaponEquipped == true): #Starts Combat if Weapon is Equipped
		Combat()
	
	#Charging System
	if (CombatPhase == PhaseSpecialAttack): #Sets Combatphase to Special Attack
		if (Input.is_action_pressed("special attack") && SpecialAvaliable): #Checks whether mouse button is held
			SpecialButtonHeld = true
		else:
			SpecialButtonHeld = false
			SpecialAvaliable = false
			CombatPhase = null
	
	
	if (SpecialButtonHeld): #If the mouse button is held:
		Chargetimer += delta #Checks how long button is held
		print(Chargetimer)
	elif (Chargetimer > 0): #If mouse let go
		Charging(Chargetimer)
		Chargetimer = 0 #Sets Charging Timer to 0
		print(Chargetimer)
		timer.start(2) #Cooldown
#===========================================================================#
# Health System:

	HealthSystem()
#===========================================================================#
# Testing:
	
	

#============================================================================

func EquipingWeapon() -> void: #Function for Equiping Weapon
	##Equiping Weapon
	if (Globals.SpearObtained && Globals.WeaponEquipped == false && Input.is_action_just_pressed("equip weapon")):
		print("OMG I GOT A SPEAR") #Spear is equipped... Ok come on that one's obvious
		Globals.WeaponEquipped = true
		
	##Unequiping Weapon
	elif (Globals.WeaponEquipped == true && Input.is_action_just_pressed("equip weapon")):
		print("There goes my spear :c")
		Globals.WeaponEquipped = false
		$WeaponHitBox.visible = false

	##Makes sure hitbox is disabled if weapon is not equipped
	elif (Globals.WeaponEquipped == false):
		$WeaponHitBox.visible = false
		$WeaponHitBox/CollisionShape2D.disabled = true

	##Enable Combat System when weapon is equipped

func Combat() -> void: #Function for Combat
	#Left Click Attacking
	if (Input.is_action_just_pressed("attack") && !isAttacking && is_on_floor()):
		CombatPhase = PhaseBasicAttack
		print(CombatPhase)
		BasicAttack();
		print(CombatPhase)
	#Left Click Air
	elif (Input.is_action_just_pressed("attack") && !isAttacking && !is_on_floor()):
		CombatPhase = PhaseAirAttack
		AirAttack();
	#Special Attack
	elif (Input.is_action_just_pressed("special attack") && !isAttacking):
		CombatPhase = PhaseSpecialAttack
	
func BasicAttack () -> void: #Function for Basic Attacking (Done?)
	isAttacking = true #Makes sure there's no overlap
	if (LocalXmouseposition >= 0): #Checks left or right
		$WeaponHitBox.visible = true
		$WeaponHitBox.position = Vector2(21, 3) #Changes Hitbox Position
		$WeaponHitBox/CollisionShape2D.disabled = false
		timer.start(0.2) #Cooldown
		print("right") 
		animated_sprite_2d.flip_h= false #Flips or unflips slash animation
		player_sprite.flip_h = false #Flips or unflips player animation
		animated_sprite_2d.play("default") #Sets animation to Slash
	elif (LocalXmouseposition < 0):
		$WeaponHitBox.visible = true
		$WeaponHitBox/CollisionShape2D.disabled = false
		$WeaponHitBox.position = Vector2(-21, 3)
		timer.start(0.2)
		print("left")
		player_sprite.flip_h = true
		animated_sprite_2d.flip_h= true
		animated_sprite_2d.play("default")
	timer.start(0.2)
	
func AirAttack() -> void: #Function for Air Attacks (Placeholder)
	pass
	
	

#============================================================================

func Charging(ButtonHeld: float) -> void: #Function for Charging
	if (ButtonHeld < 1): #Checks "Stages" of charge
		$Anchor/Spawner.ProjSpeed = 250 #Changes Projectile Speed
		$Anchor/Spawner.shoot() #Shoots Projectile
	elif (ButtonHeld < 2):
		$Anchor/Spawner.ProjSpeed = 500
		$Anchor/Spawner.shoot()
	elif (ButtonHeld > 2):
		$Anchor/Spawner.ProjSpeed = 1000
		$Anchor/Spawner.shoot()

func _on_area_2d_body_entered(body: Node2D) -> void:
	hit_checkpoint = true


func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()


func _on_button_pressed() -> void:
	if hit_checkpoint :
		Saveload.contents_to_save.checkpoint_hit = true
		Saveload._save()

	if mask_picked_up:
		Saveload.contents_to_save.mask_collected = true
		Saveload._save()
		Saveload.contents_to_save.spear_collected = true
		Saveload._save()


func XYScalar(x: float, y: float) -> float:
	Scalartesting = y/x
	return Scalartesting
	

func _on_timer_timeout() -> void:
	if (CombatPhase == 0): #Disables Hitbox for Basic Attack
		$WeaponHitBox.visible = false
		$WeaponHitBox/CollisionShape2D.disabled = true
		isAttacking = false
		print("TIME OUT")
		CombatPhase = null
	elif (CombatPhase == 1):
		pass
	else:
		CombatPhase = null
		
	if (!SpecialAvaliable): #Makes Special Avaliable
		print("TIME OUT SPECIAL")
		SpecialAvaliable = true
	else:
		CombatPhase = null

func HealthSystem() -> void:
	if (Health <= 0):
		get_tree().reload_current_scene()
	pass
	
func Hurt(Damage: int,Knockback: Vector2, Direction: int):
	Health -= Damage #Subtracts damage from player health
	print(velocity)
	velocity.x = (velocity.x + Knockback.x) * (Direction) #Player knockback from enemy
	velocity.y = velocity.y + Knockback.y
	print(Health)
