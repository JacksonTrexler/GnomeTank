extends Node2D

var tile_map_position = Vector2()
var selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move(move_pos):
	var tile_map = get_node("root/Node2d/GnomeBoard")
	if not tile_map.is_tile_occupied(move_pos):
		pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		global_position = get_global_mouse_position()
		update_tile_map_position()

func update_tile_map_position():
	var tile_map = get_node("%GnomeBoard") # Adjust the path to your TileMap node
	tile_map_position = tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(tile_map_position)
	print(tile_map_position)
