class_name Shell extends MeleeWeapon

func _ready() -> void:
	self._damage = 30
	hitbox.monitoring = false

func get_damage():
	return self._damage

func fire():
	hitbox.monitoring = true

func stop_firing():
	hitbox.monitoring = false
