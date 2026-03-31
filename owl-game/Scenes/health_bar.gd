extends ProgressBar


@export var combatant: Node2D

func _ready() -> void:
	combatant.healthChanged.connect(update)
	call_deferred("update")

func update():
	value = combatant.Health * 100 / combatant.MaxHealth
	
	var local_fill = get_theme_stylebox("fill").duplicate()
	
	if value < 45:
		local_fill.bg_color = Color(1,0,0)
	else:
		local_fill.bg_color = Color(0,1,0)
	
	add_theme_stylebox_override("fill", local_fill)
