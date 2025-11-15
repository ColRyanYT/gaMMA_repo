class_name Player extends CharacterBody2D

@onready var hand = $Hand
@onready var sprite = $Sprite
@onready var dash_effect = $Sprite/DashEffect
@onready var shell = $Shell

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

const DASH_MULTIPLIER = 3
const DASH_TIME = 0.6

signal dash
var dashing: bool = false
var dash_velocity = Vector2(0,0)

var direction = Vector2.ZERO
var dash_direction = Vector2.ZERO

var my_weapon_scene: PackedScene
var my_weapon: Weapon

var max_health = 100
var current_health = max_health

var normal_texture = preload("res://Actors/armadillo.png")
var ball_texture = preload("res://Actors/ball.png")

func get_current_health():
	return current_health

# default weapon is claws for now
func _ready() -> void:
	my_weapon_scene = preload("res://Weapons/claws.tscn")
	my_weapon = my_weapon_scene.instantiate()
	hand.add_child(my_weapon)

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var mouse_position = get_global_mouse_position()
	var direction_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var direction_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = Vector2(direction_x, direction_y).normalized()
	
	dash_direction = self.global_position.direction_to(get_global_mouse_position())
	
	if Input.is_action_just_pressed("space") and not dashing:
		start_dash(mouse_position)
	elif dashing:
		velocity = dash_velocity
	elif direction_x or direction_y:
		velocity = direction * SPEED
		move_and_slide()
	else:
		move_and_slide()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
		
	
	if dashing:
		var collision_data = move_and_collide(velocity * delta)
		bounce(collision_data) 
	

func start_dash(mouse_position: Vector2) -> void:
	dashing = true
	sprite.texture = ball_texture
	dash.emit()

	dash_velocity = dash_direction * SPEED * DASH_MULTIPLIER
	dash_effect.look_at(mouse_position)
	
	shell.fire()
	# Use a coroutine to end dash after DASH_TIME seconds
	await get_tree().create_timer(DASH_TIME).timeout
	end_dash()


func end_dash() -> void:
	dashing = false
	sprite.texture = normal_texture
	shell.stop_firing()

func _process(_delta: float) -> void:
	hand.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		my_weapon.fire()
	
	if current_health <= 0:
		get_tree().paused = true
		await get_tree().create_timer(1).timeout
		get_tree().quit()

func bounce(collision_data: KinematicCollision2D):
	if collision_data:
		dash_velocity = velocity.bounce(collision_data.get_normal())
		$Sprite/DashEffect.set_rotation(dash_velocity.angle())
		#var collided = collision_data.get_collider().get_parent()
		#print(collided.get_class())
		#if collided.is_class("Enemy"):
			#current_health -= collided.get_damage()

func take_damage(damage_value):
	current_health -= damage_value

func _on_enemy_body_entered(_body: Node2D) -> void:
	pass
	
