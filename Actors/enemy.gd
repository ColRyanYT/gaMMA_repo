class_name Enemy extends CharacterBody2D

@export var player: Node2D

@export var max_health = 100.0

var current_health = max_health
var _damage = 10

@onready var blood = $Blood/CPUParticles2D
@onready var sprite = $Sprite2D

func get_damage():
	return _damage

func check_damage():
	if current_health <= 0.0:
		sprite.visible = false
		await get_tree().create_timer(blood.lifetime).timeout
		queue_free()

func take_damage(inflictor :Object):
	var damage = inflictor.get_damage()
	blood.emitting = true
	current_health -= damage

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(self)
