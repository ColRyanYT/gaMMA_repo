class_name Chest extends StaticBody2D

var rng = RandomNumberGenerator.new()
@onready var area = $Area2D

var opened = false

func _ready() -> void:
	rng.randomize()

func spawn_in_item(path):
	var chosen_scene = load(path)
	var chosen_object = chosen_scene.instantiate()
	add_child(chosen_object)
	var old_position = chosen_object.global_position
	chosen_object.global_position = Vector2(old_position.x, old_position.y-50)
	chosen_object.find_level()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if opened:
			area.monitoring = false
			return
		opened = true
		var dir = DirAccess.open("res://Weapons/PossibleDrops/")
		var files_array = []
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				files_array.append(file_name)
				file_name = dir.get_next()
		var chosen = rng.randi_range(0, files_array.size()-1)
		var full_path = "res://Weapons/PossibleDrops/" + files_array[chosen]
		call_deferred("spawn_in_item", full_path)
