class_name Claws extends MeleeWeapon

@onready var anim = $Area2D/SlashAnim
@onready var timer = $Timer

var anim_playing = false

var old_rotation = Vector3.ZERO
var frozen_rotation = Vector3.ZERO

func _ready() -> void:
	hitbox.monitoring = false
	self._damage = 40

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
