extends CanvasLayer

@onready var player = get_parent().get_node("Player")
@onready var health = $HealthBar

func _process(_delta: float) -> void:
	health.value = player.get_current_health()
