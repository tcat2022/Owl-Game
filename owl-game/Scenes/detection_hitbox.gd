extends Area2D

var PlayerLocked = false
var DistanceToPlayer
var Direction


func _physics_process(delta: float) -> void:
	
	Direction =  $"..".direction #Gets Enemy Direction
	if (Direction < 0 && $CollisionShape2D.position.x > 0): #Enemy turned
		$CollisionShape2D.position.x *= -1 #Flips Detection collision
	elif (Direction > 0 && $CollisionShape2D.position.x < 0):
		$CollisionShape2D.position.x *= -1

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")): #Checks if players in detection
		PlayerLocked = true #Enables Enemy Combaat
		print("Found Player")
		print(body.global_position.x) 
		print(global_position.x)
		DistanceToPlayer = body.global_position.x - global_position.x #Get Distance to 
		#player from enemy
		print("Distance to player:", DistanceToPlayer)
		if (DistanceToPlayer < 0 && Direction > 0 && $"../RayCast2D".is_colliding()): 
			#If player enters behind the detection area (if Distance from player is -)
			$CollisionShape2D.position.x *= -1 #Flips Collision position
			$"..".direction *= -1 #Flips velocity
		elif (DistanceToPlayer > 0 && Direction < 0 && $"../RayCast2D".is_colliding()):
			#If player enters behind the detection area (if Distance from player is +)
			$CollisionShape2D.position.x *= -1
			$"..".direction *= -1
		

func _on_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")): #Makes sure its the player exiting detection
		print("Lost Player")
		PlayerLocked = false #turns off enemy combat
		DistanceToPlayer = body.global_position.x - global_position.x #Get Distance to player from enemy
		if (DistanceToPlayer < 0 && Direction > 0 && $"../RayCast2D".is_colliding()): 
			#If player enters behind the detection area (if Distance from player is -)
			$CollisionShape2D.position.x *= -1 #Flips Collision position
			$"..".direction *= -1 #Flips velocity
		elif (DistanceToPlayer > 0 && Direction < 0 && $"../RayCast2D".is_colliding()):
			#If player enters behind the detection area (if Distance from player is +)
			$CollisionShape2D.position.x *= -1
			$"..".direction *= -1
