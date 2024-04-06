extends TileMap

var second_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var gnome_scene = load("res://gnome.tscn")
	
	var tokens = get_used_cells(1)
	for token in tokens:
		var gnome_instance = gnome_scene.instantiate()
		#gnome_instance.owner = self
		gnome_instance.tile_map = self
		gnome_instance.owner = self
		add_child(gnome_instance)
		gnome_instance.tile_map_position = token
		gnome_instance.global_position = map_to_local(token)
	print("gbeady")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	second_timer += delta
	if second_timer >= 1.0:
		second_timer -= 1.0
		for gnome in get_children():
			if gnome is Gnome:
				for ap in range(gnome.action_points):
					gnome.action_plan()

func is_tile_occupied(move_pos):
	print(get_used_cells(1))
	return false
	
func is_tile_empty(x: int, y: int) -> bool:
	return false
	#return get_cell(x,y) == get_cell
	
func tile_move(token_pos: Vector2i, dest_pos: Vector2i, move_layer: int = 1, floor_layer: int = 0) -> bool:
	if get_cell_source_id(move_layer,dest_pos) == -1 and get_cell_source_id(floor_layer,dest_pos) != -1:
		set_cell(move_layer, dest_pos,3,get_cell_atlas_coords(move_layer,token_pos), 0)
		erase_cell(move_layer, token_pos)
		return true
	else:
		return false
