class_name RifleBase extends Weapon

@onready var shot_timer = $shot_timer
var can_shoot = false

@onready var level

func find_level():
	level = get_parent().get_parent()

func fire():
	can_shoot = false

func _on_shot_timer_timeout():
	can_shoot = true
