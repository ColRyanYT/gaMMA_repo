class_name PlayerBullet extends Bullet

func break_on_wall():
	var contacts = get_colliding_bodies()
	if contacts and not (contacts[0].in_group("Player")):
		queue_free()
