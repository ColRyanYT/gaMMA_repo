class_name RifleBase extends Weapon

@onready var shot_timer = $shot_timer
var can_shoot = false
var split_num = 1
var spread = 60
@onready var muzzle = $Muzzle
@onready var level
@onready var bullet

func set_bullet(obj):
	bullet = obj

func set_split(value):
	split_num = value

func try_fire():
	if not can_shoot:
		return

	fire()
	can_shoot = false
	shot_timer.start()

func fire():
	if split_num > 1:
		for i in range(split_num):
			
			var offset =-spread/2 + (spread / (split_num - 1)) * i
			
			process_split(offset)
	else:
		process_split(0)

func process_split(offset):
	var newbullet = bullet.instantiate()
	level.add_child(newbullet)
	newbullet.global_transform = muzzle.global_transform
	newbullet.shoot(get_parent().get_global_mouse_position(), offset)


func find_level():
	level = get_parent().get_parent()

func _on_shot_timer_timeout():
	can_shoot = true
