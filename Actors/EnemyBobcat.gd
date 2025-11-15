class_name EnemyBobcat extends Enemy

@export var speed = 150

@onready var walk = $AnimatedSprite2D
@onready var navigation_agent = $NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var next_path_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	velocity = direction * speed
	move_and_slide()

func _process(_delta: float) -> void:
	check_damage()

func pathfind() -> void:
	navigation_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	if player.global_position.distance_to(self.global_position) < 400:
		pathfind()
		walk.play("walk")
	else:
		walk.stop()
