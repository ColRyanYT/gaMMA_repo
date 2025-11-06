class_name MeleeWeapon extends Weapon

@onready var hitbox = $Area2D

var _damage = 0

func get_damage() -> int:
	return self._damage

func fire():
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(self)
