class_name Enemy extends CharacterBody2D

@export var speed = 150
@export var player: Node2D

@export var max_health = 100.0

var current_health = max_health
var _damage = 10

@onready var navigation_agent = $NavigationAgent2D
@onready var blood = $CPUParticles2D
@onready var sprite = $Sprite2D
@onready var walk = $AnimatedSprite2D

func get_damage():
	return _damage

func _process(_delta: float) -> void:
	if current_health <= 0.0:
		sprite.visible = false
		await get_tree().create_timer(blood.lifetime).timeout
		queue_free()

func _physics_process(_delta: float) -> void:
	var next_path_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	velocity = direction * speed
	move_and_slide()

func pathfind() -> void:
	navigation_agent.target_position = player.global_position

func take_damage(inflictor :Object):
	var damage = inflictor.get_damage()
	blood.emitting = true
	current_health -= damage

func _on_timer_timeout() -> void:
	if player.global_position.distance_to(self.global_position) < 400:
		pathfind()
		walk.play("walk")
	else:
		walk.stop()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(_damage)
