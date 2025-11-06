extends CharacterBody2D

@export var speed = 150
@export var player: Node2D

@export var max_health = 100.0

var current_health = max_health

@onready var navigation_agent = $NavigationAgent2D
@onready var blood = $CPUParticles2D
@onready var sprite = $Sprite2D

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
