class_name Bullet extends RigidBody2D

var speed = 300
var move_direction := Vector2.ZERO

@onready var lifetime = $Lifetime

#func shoot(target_pos):
#	look_at(target_pos)
#	
#	move_direction = (target_pos - global_position).normalized()
#	linear_velocity = move_direction * speed

func shoot(target_pos, offset):
	var radians = deg_to_rad(offset)
	var aim_direction = (target_pos - global_position).normalized()
	aim_direction = aim_direction.rotated(radians)
	
	linear_velocity = aim_direction * speed
	rotation = aim_direction.angle()

func _on_lifetime_timeout() -> void:
	queue_free()
