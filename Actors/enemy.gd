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
