extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_dash() -> void:
	visible = true
	$DashTimer.start(0.5)

func _on_dash_timer_timeout() -> void:
	visible = false
	$"../../Sprite".texture = load("res://Actors/armadillo.png")
