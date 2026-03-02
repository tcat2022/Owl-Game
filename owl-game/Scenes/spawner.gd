extends Node2D
var ProjSpeed
@onready var main = get_tree().get_root().get_node("Node2D")
@onready var projectile = load("res://Scenes/throw_spear_hit_box.tscn")
@export var default_direction = Vector2.RIGHT
var GlobalMousePos

func _process(delta: float) -> void:
	GlobalMousePos = get_global_mouse_position()
	rotation = global_position.angle_to_point(GlobalMousePos)

func shoot():
	var instance = projectile.instantiate()
	instance.SPEED = ProjSpeed
	instance.dir = rotation + PI/2
	print(instance.dir)
	instance.spawnPos = global_position
	instance.spawnRotation = rotation + PI/2
	main.add_child.call_deferred(instance)
