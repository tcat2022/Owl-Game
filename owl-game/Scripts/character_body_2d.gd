extends CharacterBody2D
@onready var node_2d: Area2D = $"../Node2D"
@onready var node_2d_2: Area2D = $"../Node2D2"

var hit_checkpoint = false
var test := 0
var mask_picked_up = false
var doubleJump = 1
var double = true
const SPEED = 175.0
const JUMP_VELOCITY = -250.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	
	print(test)
		
	
	if Input.is_action_just_pressed("pick up") and Globals.can_pick_up:
		node_2d.queue_free()
		mask_picked_up = true
		
	if Input.is_action_just_pressed("pick up") and Globals.can_pick_up_spear:
		node_2d_2.queue_free()
		mask_picked_up = true
		

	if is_on_floor():
		doubleJump = 0
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Handle jump.
	if Input.is_action_just_pressed("jump") and doubleJump != 2:
		doubleJump += 1
		velocity.y = JUMP_VELOCITY
		sprite_2d.play("idle")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		sprite_2d.play("walking")
		if direction == -1:
			sprite_2d.flip_h = true
		else:
			sprite_2d.flip_h = false
		
		velocity.x = direction * SPEED
		
	else:
		sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	position.x += test
	move_and_slide()



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
