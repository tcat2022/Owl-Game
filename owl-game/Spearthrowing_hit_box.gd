extends CharacterBody2D

@export var SPEED = 500

var spawnPos: Vector2
var dir: float
var spawnRotation: float

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRotation
	

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()
