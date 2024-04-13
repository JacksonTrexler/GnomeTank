extends TileMap

var second_timer = 0.0
var tokens

# Called when the node enters the scene tree for the first time.
func _ready():
	var gnome_scene = load("res://gnome.tscn")
	tokens = get_used_cells(1)
	
	for token in tokens:
		var gnome_instance = gnome_scene.instantiate()
		var gnome_type_script = determine_gnome_script(token)
		if gnome_type_script:
			gnome_instance.script = load(gnome_type_script)
		gnome_instance.tile_map = self
		add_child(gnome_instance)
		gnome_instance.tile_map_position = token
		gnome_instance.global_position = map_to_local(token)

func get_gnome(token):
	for gnome in get_children():
		if token == Vector2i(gnome.tile_map_position) and gnome is Gnome:
			return gnome

func determine_gnome_script(token):
	var atlas_coordinates = get_cell_atlas_coords(1, token)
	print(atlas_coordinates)
	match atlas_coordinates:
		Vector2i(7,1):
			return "res://Scripts/Gnomes/GnomeLongerWithUs.gd"
		Vector2i(2,0):
			return "res://Scripts/Gnomes/Gnecromancer.gd"
		Vector2i(3,0):
			return "res://Scripts/Gnomes/GnotLongForThisWorld.gd"
		_:
			return "res://Scripts/Gnomes/GnobodyInParticular.gd"

func determine_gnome_tile(gnome_type):
	match gnome_type:
		"GNECROMANCER":
			return Vector2i(2,0)
		"GNIGHT":
			return Vector2i(3,1)
		"GNUN":
			return Vector2i(6,0)
		"GNAVE":
			return Vector2i(6,1)
		"GNOME_LONGER_WITH_US":
			return Vector2i(7,1)
		"MAGICIAGN":
			return Vector2i(1,1)
		"GNOT_LONG_FOR_THIS_WORLD":
			return Vector2i(3,0)
		_:
			return Vector2i(4,1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	second_timer += delta
	if second_timer >= 1.0:
		second_timer -= 1.0
		for gnome in get_children():
			if gnome is Gnome:
				for ap in range(gnome.action_points):
					gnome.action_plan()

func tile_move(token_pos: Vector2i, dest_pos: Vector2i, move_layer: int = 1, floor_layer: int = 0) -> bool:
	if get_cell_source_id(move_layer,dest_pos) == -1 and get_cell_source_id(floor_layer,dest_pos) != -1:
		set_cell(move_layer, dest_pos,3,get_cell_atlas_coords(move_layer,token_pos), 0)
		erase_cell(move_layer, token_pos)
		return true
	else:
		return false
