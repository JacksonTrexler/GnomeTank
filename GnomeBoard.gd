extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_tile_occupied(move_pos):
	print(get_used_cells(1))
	return false
	
func is_tile_empty(x: int, y: int) -> bool:
	return false
	#return get_cell(x,y) == get_cell
