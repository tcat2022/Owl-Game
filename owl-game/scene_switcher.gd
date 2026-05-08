extends Area2D

@export var current_scene : bool
@export var new_scene : bool
var Player
var Interacted
var isinRange = false
var CityLevel = "res://Scenes/node_2d.tscn"
var SceneArray = [
	["JunkyardEntrance1", "CityLevel", CityLevel],
	["Placeholder1", "Placeholder2", null]
	]

func _physics_process(delta: float) -> void:
	print(isinRange)
	
	if (isinRange && Player.has_method("Interact")): #Checks if player has method Interact and is in Range
		if (Player.Interact()): #Chekcs if Interact Method returns true
			SceneChange(name) #Loads name of Area2D into Scene Changer Function
		

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #Checks if Player is in range
		isinRange = true
		Player = body #If player is in range, set Player as body(player)
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		isinRange = false
		Player = null

func SceneChange(name: String):
	for i in len(SceneArray): #For loop with i being the number of objects in the SceneArray
		print(SceneArray[i][0]) #Prints out Array
		if (name == SceneArray[i][0]): #If Area2D name matches with one of the Arrays
			print("Found, teleporting to: ", SceneArray[i][1]) #Prints out destination
			get_tree().change_scene_to_file(SceneArray[i][2]) #Changes scene to destination
