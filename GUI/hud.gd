extends CanvasLayer

@onready var player = get_parent().get_node("Player")
@onready var health = $HealthBar
@onready var crosshair = $Crosshair

func _process(_delta: float) -> void:
	health.value = player.get_current_health()
	crosshair.global_position = get_viewport().get_mouse_position() - Vector2(40, 40)
