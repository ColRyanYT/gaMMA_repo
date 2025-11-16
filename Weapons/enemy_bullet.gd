class_name EnemyBullet extends Bullet

var _damage = 20

# this shouldn't be a thing, if you want enemies bullets to bounce
# make a new function and pass it into the physics process
# of the class with no subclasses (leaf in heirarchy)
func _physics_process(_delta: float) -> void:
	var contacts = get_colliding_bodies()
	if contacts and not (contacts[0] is Enemy):
		queue_free()
