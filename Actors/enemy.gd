<<<<<<< HEAD
extends Area2D

var health = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("AHH")
	health -= 1
	if health == 0:
		visible = false
=======
extends CharacterBody2D

@export var speed = 200
@export var player: Node2D

@onready var navigation_agent = $NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var next_path_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)
	velocity = direction * speed
	move_and_slide()

func pathfind() -> void:
	navigation_agent.target_position = player.global_position

func _on_timer_timeout() -> void:
	if player.global_position.distance_to(self.global_position) < 400:
		pathfind()
>>>>>>> 468245522f4e54c07e155680e50c8a5c44be5757
