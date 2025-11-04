extends Node

@onready var camera = $Camera2D
@onready var player = $Player
@onready var tile_map = $TileMapLayer

@export var follow_speed = 4.0

var rng = RandomNumberGenerator.new()

var num_rooms = 40

var tile_array = []

var grid_size = 64

var tile_codes = {
	"floor": 0,
	"wall": 1
}


class Room:
	var x_size: int
	var y_size: int
	var x_offset: int
	var y_offset: int
	var x_in_grid: int
	var y_in_grid: int
	# maybe these should be even but idk
	var min_roomsize = 6
	var max_roomsize = 10
	var max_room_offset = 24
	
	var grid_coords_array = []
	
	func _initialise(rng, grid_size):
		self.x_size = rng.randi_range(self.min_roomsize, self.max_roomsize)
		self.y_size = rng.randi_range(self.min_roomsize, self.max_roomsize)
		self.x_offset = rng.randi_range(-self.max_room_offset, self.max_room_offset)
		self.y_offset = rng.randi_range(-self.max_room_offset, self.max_room_offset)
		
		self.x_in_grid = int(grid_size/2) + x_offset
		self.y_in_grid = int(grid_size/2) + y_offset
		
		grid_coords_array.clear()
		
		for i in range(self.x_size):
			self.grid_coords_array.append([])
			for j in range(self.y_size):
				grid_coords_array[i].append([null, null])
		
		var x_pos_in_room = 0
		for k in range(-int(x_size / 2.0), int((x_size + 1) / 2.0)):
			var y_pos_in_room = 0
			for p in range(-int(y_size / 2.0), int((y_size + 1) / 2.0)):
				grid_coords_array[x_pos_in_room][y_pos_in_room][0] = x_in_grid + k
				grid_coords_array[x_pos_in_room][y_pos_in_room][1] = y_in_grid + p
				y_pos_in_room += 1
			x_pos_in_room += 1

func setup_procgen() -> void:
	for i in range(grid_size):
		tile_array.append([])
		for j in range(grid_size):
			tile_array[i].append(tile_codes.wall)
	
	set_tile_values()

func set_tile_values() -> void:
	var room_centers = []
	
	for i in range(num_rooms):
		var room = Room.new()
		room._initialise(rng, grid_size)
		
		# force one central room
		if i == 0:
			room.x_offset = 0
			room.y_offset = 0
			
		room_centers.append(Vector2i(room.x_in_grid, room.y_in_grid))
		
		for j in range(room.x_size):
			for k in range(room.y_size):
				var gx = room.grid_coords_array[j][k][0]
				var gy = room.grid_coords_array[j][k][1]
				if gx < 0 or gx >= grid_size or gy < 0 or gy >= grid_size:
					continue
				if tile_array[room.grid_coords_array[j][k][0]][room.grid_coords_array[j][k][1]] == tile_codes.wall:
					tile_array[room.grid_coords_array[j][k][0]][room.grid_coords_array[j][k][1]] = tile_codes.floor
	
	place_tiles()
	
	var player_start = find_nearest_floor(int(grid_size / 2.0), int(grid_size / 2.0))
	if player_start == null:
		print("No floor tile found! Skipping flood fill.")
		return
	
	connect_rooms(room_centers)
	
	var visited = flood_fill(player_start.x, player_start.y)
	for x in range(grid_size):
		for y in range(grid_size):
			if tile_array[x][y] == tile_codes.floor and not visited[x][y]:
				tile_array[x][y] = tile_codes.wall
	
	place_tiles()

func place_tiles() -> void:
	for i in range(grid_size):
		for j in range(grid_size):
			if tile_array[i][j] == tile_codes.floor:
				tile_map.set_cell(Vector2i(i, j), 1, Vector2i(5, 0))
			else:
				tile_map.set_cell(Vector2i(i, j), 1, Vector2i(0, 0))

## CHATGPT CODE !!
func flood_fill(start_x, start_y):
	var visited = []
	for x in range(grid_size):
		visited.append([])
		for y in range(grid_size):
			visited[x].append(false)
	
	var queue = [Vector2i(start_x, start_y)]
	while queue.size() > 0:
		var current = queue.pop_front()
		var x = current.x
		var y = current.y
		
		if x < 0 or x >= grid_size or y < 0 or y >= grid_size:
			continue
		if visited[x][y] or tile_array[x][y] == tile_codes.wall:
			continue
		
		visited[x][y] = true
		
		for dir in [Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1)]:
			queue.append(current + dir)
	return visited

func find_nearest_floor(cx: int, cy: int) -> Vector2i:
	var radius = 0
	while radius < int(grid_size / 2.0):
		for dx in range(-radius, radius + 1):
			for dy in range(-radius, radius + 1):
				var x = cx + dx
				var y = cy + dy
				if x >= 0 and x < grid_size and y >= 0 and y < grid_size:
					if tile_array[x][y] == tile_codes.floor:
						return Vector2i(x, y)
		radius += 1
	return Vector2i.ZERO

func connect_rooms(centers: Array) -> void:
	if centers.size() < 2:
		return

	for i in range(centers.size() - 1):
		var a = centers[i]
		var b = centers[i + 1]

		var pos = a
		var goal = b

		# Randomly decide which axis to move first
		var move_horizontal_first = rng.randf() < 0.5

		while pos != goal:
			# Carve floor at current position
			if pos.x >= 0 and pos.x < grid_size and pos.y >= 0 and pos.y < grid_size:
				tile_array[pos.x][pos.y] = tile_codes.floor

			# Add a little “wander” to the path
			if rng.randf() < 0.2:
				move_horizontal_first = not move_horizontal_first

			# Decide next step
			if move_horizontal_first:
				if pos.x < goal.x:
					pos.x += 1
				elif pos.x > goal.x:
					pos.x -= 1
				elif pos.y < goal.y:
					pos.y += 1
				elif pos.y > goal.y:
					pos.y -= 1
			else:
				if pos.y < goal.y:
					pos.y += 1
				elif pos.y > goal.y:
					pos.y -= 1
				elif pos.x < goal.x:
					pos.x += 1
				elif pos.x > goal.x:
					pos.x -= 1

func _ready() -> void:
	rng.randomize()
	setup_procgen()
	
	player.position.x = 10 * int(grid_size/2.0)
	player.position.y = 10 * int(grid_size/2.0)

func _input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		tile_array.clear()
		setup_procgen()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera.position != player.position:
		camera.position = camera.position.lerp(player.position, delta * follow_speed)
