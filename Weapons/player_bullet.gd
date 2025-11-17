class_name PlayerBullet extends Bullet

var contacts
var _damage = 20

func _ready() -> void:
	speed = 800

func get_damage():
	return _damage

func check_contacts():
	contacts = get_colliding_bodies()

func break_on_wall():
	if contacts and not (contacts[0] is Enemy):
		queue_free()

func damage_enemies():
	if contacts and (contacts[0] is Enemy):
		contacts[0].take_damage(self)
		queue_free()

# idea: include some other functions for different behvaiors and
# substitute them in when needed like strategy pattern
func _process(_delta: float) -> void:
	check_contacts()
	break_on_wall()
	damage_enemies()
