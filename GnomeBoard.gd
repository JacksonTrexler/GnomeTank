extends TileMap


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
	pass

func is_tile_occupied(move_pos):
	print(get_used_cells(1))
	return false
	
func is_tile_empty(x: int, y: int) -> bool:
	return false
	#return get_cell(x,y) == get_cell
	
func tile_move(token_pos: Vector2i, dest_pos: Vector2i, layer: int = 1) -> bool:
	if get_cell_source_id(layer,dest_pos) == -1:
		set_cell(layer, dest_pos,3,get_cell_atlas_coords(layer,token_pos), 0)
		erase_cell(layer, token_pos)
		return true
	else:
		return false
