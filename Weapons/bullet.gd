class_name Bullet extends RigidBody2D

var speed = 300
var move_direction := Vector2.ZERO

@onready var lifetime = $Lifetime

func shoot(target_pos):
	look_at(target_pos)
	
	move_direction = (target_pos - global_position).normalized()
	linear_velocity = move_direction * speed

func _on_lifetime_timeout() -> void:
	queue_free()
