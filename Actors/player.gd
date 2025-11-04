extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
signal dash
var dashing: bool = false
var mouse_position = null
var dash_velocity = Vector2(0,0)

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var speed_boost = 1
	mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	if Input.is_action_pressed("ui_select") and not dashing:
		$Sprite.texture = load("res://Actors/ball.png")
		dash.emit()
		dashing = true
		speed_boost = 3
		velocity = (direction * SPEED * speed_boost)
		dash_velocity = velocity
		$Sprite/DashEffect.look_at(mouse_position)
	elif dashing:
		velocity = dash_velocity
	elif Input.is_action_pressed("forward"):
		velocity = (direction * SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.x, 0, SPEED)


	var collision = move_and_slide()
	if collision:
		dash_velocity = -dash_velocity
		$Sprite/DashEffect.rotate(deg_to_rad(180))



func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_enemy_body_entered(body: Node2D) -> void:
	if dashing:
		dash_velocity = -dash_velocity
		$Sprite/DashEffect.rotate(deg_to_rad(180))
