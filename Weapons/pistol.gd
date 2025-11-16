class_name Pistol extends RifleBase

@onready var bullet = preload("res://Weapons/player_bullet.tscn")
@onready var muzzle = $Muzzle

var level

func ready():
	level = get_parent().get_parent()

func fire():
	var newbullet = bullet.instantiate()
	level.add_child(newbullet)
	newbullet.global_transform = muzzle.global_transform
