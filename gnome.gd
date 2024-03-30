extends Node2D

var tile_map_position = Vector2()
var selected = false
var base_speed = 25
var speed = 25 # Units per second
var moving = false
var target_global_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		var direction = target_global_position - global_position
		var distance_to_move = speed * delta
		var distance_to_target = direction.length()
		
		speed = (base_speed * 2 + (base_speed * distance_to_target/ max(distance_to_move,1))) / 3
		#print(speed)
		if distance_to_target <= distance_to_move:
			# Close enough to snap to the target.
			global_position = target_global_position
			moving = false
		else:
			# Move towards the target, clamping the movement to the distance to the target.
			global_position += direction.normalized() * distance_to_move

func move(move_pos):
	var tile_map = get_node("%GnomeBoard")
	if not tile_map.is_tile_occupied(move_pos):
		print("before: ", tile_map_position)
		tile_map_position = tile_map.local_to_map(move_pos)
		print("after: ", tile_map_position)
		target_global_position = tile_map.map_to_local(tile_map_position)# + Vector2(tile_map.rendering_quadrant_size / 2, tile_map.rendering_quadrant_size / 2)
		#print(target_global_position)
		moving = true

func move_map(move_pos):
	var tile_map = get_node("%GnomeBoard")
	if not tile_map.is_tile_occupied(move_pos):
		#print("before: ", tile_map_position)
		tile_map_position = move_pos
		#print("after: ", tile_map_position)
		target_global_position = tile_map.map_to_local(tile_map_position)# + Vector2(tile_map.rendering_quadrant_size / 2, tile_map.rendering_quadrant_size / 2)
		#print(target_global_position)
		moving = true
	else:
		bonk()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		global_position = get_global_mouse_position()
		update_tile_map_position()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		move(get_global_mouse_position())
		#update_tile_map_position()
	if event.is_action_pressed("ui_accept"): # Checking if spacebar is pressed
		wander()

func update_tile_map_position():
	var tile_map = get_node("%GnomeBoard") # Adjust the path to your TileMap node
	tile_map_position = tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(tile_map_position)
	print(tile_map_position)
	
func wander():
	var directions = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
	var random_index = randi() % directions.size()
	var desired_move = Vector2(tile_map_position.x + directions[random_index].x,tile_map_position.y + directions[random_index].y)
	move_map(desired_move)

func bonk():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 1)
