class_name Claws extends Weapon

@onready var anim = $Area2D/SlashAnim
@onready var timer = $Timer
@onready var hitbox = $Area2D

var _damage = 40

var anim_playing = false

var old_rotation = Vector3.ZERO
var frozen_rotation = Vector3.ZERO

func _ready() -> void:
	hitbox.monitoring = false

func get_damage() -> int:
	return self._damage

func fire():
	hitbox.monitoring = true
	anim_playing = true
	timer.start()
	frozen_rotation = self.global_rotation
	anim.visible = true

func _process(_delta: float) -> void:
	## NOT FULLY WORKING
	if anim_playing:
		self.global_rotation = frozen_rotation
	else:
		self.global_rotation = get_parent().global_rotation

func _on_timer_timeout() -> void:
	anim.visible = false
	anim_playing = false
	hitbox.monitoring = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(self)
