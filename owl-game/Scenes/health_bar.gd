extends ProgressBar

#export variable that connects the health bar to the combatant
@export var combatant: Node2D

#signals when the combatant gets damaged and calls update to load initial health
func _ready() -> void:
	combatant.healthChanged.connect(update)
	call_deferred("update")

func update():
	#sets the health bar = to the combatants health 
	value = combatant.Health * 100 / combatant.MaxHealth
	
	#creates a duplicant style box so that each combatants health bar displays indpendantly
	var local_fill = get_theme_stylebox("fill").duplicate()
	#changes the color of bar based on health status
	if value < 45:
		local_fill.bg_color = Color(1,0,0)
	elif value < 70:
		local_fill.bg_color = Color(1,1,0)
	else:
		local_fill.bg_color = Color(0,1,0)
	#applies the local overide
	add_theme_stylebox_override("fill", local_fill)
