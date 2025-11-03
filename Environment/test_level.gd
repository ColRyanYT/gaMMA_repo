extends Node2D

@onready var camera = $Camera2D
@onready var player = $Player

@export var follow_speed = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera.position != player.position:
		camera.position = camera.position.lerp(player.position, delta * follow_speed)
