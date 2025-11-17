class_name Shotgun extends RifleBase

@onready var selected_bullet = preload("res://Weapons/player_bullet.tscn")

func _ready() -> void:
	set_bullet(selected_bullet)
	split_num = 5
