extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
signal dash
var dashing: bool = false
var mouse_position = null
var dash_velocity = Vector2(0,0)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var speed_boost = 1
	mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	if (Input.is_action_pressed("shift") or Input.is_action_just_pressed("shoot")) and not dashing:
		$Sprite.texture = load("res://Actors/ball.png")
		dash.emit()
		dashing = true
		speed_boost = 3
		velocity = (direction * SPEED * speed_boost)
		dash_velocity = velocity
		$Sprite/DashEffect.look_at(mouse_position)
	elif dashing:
		velocity = dash_velocity
	elif direction_x or direction_y:
		velocity = (Vector2(direction_x, direction_y) * SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)


	var collision_data = move_and_collide(velocity * delta)
	bounce(collision_data) 


func bounce(collision_data):
	if collision_data:
		dash_velocity = velocity.bounce(collision_data.get_normal())
		print(velocity)
		$Sprite/DashEffect.set_rotation(dash_velocity.angle())
	

func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_enemy_body_entered(body: Node2D) -> void:
	pass
	
