class_name ShotgunEnemy extends Enemy

@onready var timer = $Timer
@onready var bullet = preload("res://Weapons/bullet.tscn")

var rng = RandomNumberGenerator.new()

var direction = 0
var direction_vector = Vector2.ZERO
var SPEED = 150

var directions = {
	0: Vector2(-1,0),
	1: Vector2(1,0),
	2: Vector2(0,1),
	3: Vector2(0,-1)
}

func _physics_process(delta: float) -> void:
	
	velocity = direction_vector * SPEED
	
	var collision_data = move_and_collide(velocity * delta)
	if collision_data:
		set_direction()

func _process(_delta: float) -> void:
	check_damage()

func _ready() -> void:
	rng.randomize()
	timer.start()
	set_direction()

func set_direction():
	# ensure the new direction is different from the old one
	var old_direction = direction
	while true:
		var new_dir = rng.randi_range(0, 3)
		if new_dir != old_direction:
			direction = new_dir
			break

	direction_vector = directions[direction]

func _on_timer_timeout() -> void:
	set_direction()

func shoot():
	var newbullet = bullet.instantiate()
	get_parent().add_child(newbullet)
	newbullet.global_transform = global_transform
	newbullet.shoot(player.global_position)

func _on_shoot_timer_timeout() -> void:
	if player.global_position.distance_to(global_position) < 300:
		shoot()
