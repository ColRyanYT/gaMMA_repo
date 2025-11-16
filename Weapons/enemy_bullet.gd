class_name EnemyBullet extends Bullet

var _damage = 20

func _physics_process(_delta: float) -> void:
	var contacts = get_colliding_bodies()
	if contacts and not (contacts[0] is Enemy):
		queue_free()
