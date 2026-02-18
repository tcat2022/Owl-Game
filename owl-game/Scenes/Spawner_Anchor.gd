extends Node2D
var GlobalMousePos
var Default_Location

@onready var main = get_tree().get_root().get_node("owl")
@onready var projectile = load("res://Scenes/throw_spear_hit_box.tscn")
@export var Default_direction = Vector2.RIGHT


func _process(delta: float) -> void:
	GlobalMousePos = get_global_mouse_position()
	rotation = global_position.angle_to_point(GlobalMousePos)

func shoot():
	var Instance = projectile.instantiate()
	Instance.spawnPos = global_position
	Instance.spawnRotation = rotation
	main.add_child.call_deferred(Instance)
