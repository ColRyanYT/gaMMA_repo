extends RigidBody2D

var speed = 300
var player: Node2D
var level
var move_direction := Vector2.ZERO
var _damage = 20

@onready var lifetime = $Lifetime

func shoot(player_pos):
	look_at(player_pos)
	
	move_direction = (player_pos - global_position).normalized()
	linear_velocity = move_direction * speed

func _physics_process(_delta: float) -> void:
	var contacts = get_colliding_bodies()
	if contacts and not (contacts[0] is Enemy):
		queue_free()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(_damage)


func _on_lifetime_timeout() -> void:
	queue_free()
