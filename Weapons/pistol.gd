class_name Pistol extends RifleBase

@onready var bullet = preload("res://Weapons/player_bullet.tscn")
@onready var muzzle = $Muzzle

func fire():
	var newbullet = bullet.instantiate()
	level.add_child(newbullet)
	newbullet.global_transform = muzzle.global_transform
	newbullet.shoot(get_parent().get_global_mouse_position())
