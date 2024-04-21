extends TileMap

var actions_taken = 0
var second_timer = 0.0
var tokens

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_gnomes_radius_diamond(Vector2i(0,0),5,1):
		set_cell(0,i,0,Vector2i(2,0))
	var gnome_scene = load("res://gnome.tscn")
	tokens = get_used_cells(1)
	
	for token in tokens:
		spawn_gnome(token,gnome_scene)

func spawn_gnome(token, gnome_scene = load("res://gnome.tscn")):
	var gnome_instance = gnome_scene.instantiate()
	var gnome_type_script = determine_gnome_script(token)
	if gnome_type_script:
		print(gnome_type_script)
		gnome_instance.script = load(gnome_type_script)
	gnome_instance.tile_map = self
	add_child(gnome_instance)
	gnome_instance.tile_map_position = token
	gnome_instance.global_position = map_to_local(token)
	#print("spawned gnome at", token, " of type: ", gnome_scene)
	return gnome_instance

func get_gnome(token):
	for gnome in get_children():
		if token == Vector2i(gnome.tile_map_position) and gnome is Gnome:
			return gnome

func determine_gnome_script(token):
	var atlas_coordinates = get_cell_atlas_coords(1, token)
	#print(atlas_coordinates)
	match atlas_coordinates:
		Vector2i(7,1):
			return "res://Scripts/Gnomes/GnomeLongerWithUs.gd"
		Vector2i(2,0):
			return "res://Scripts/Gnomes/Gnecromancer.gd"
		Vector2i(3,0):
			return "res://Scripts/Gnomes/GnotLongForThisWorld.gd"
		Vector2i(4,0):
			return "res://Scripts/Gnomes/Musiciagn.gd"
		_:
			return "res://Scripts/Gnomes/GnobodyInParticular.gd"

func determine_gnome_tile(gnome_type):
	match gnome_type:
		Gnome.GnomeTypes.GNECROMANCER:
			return Vector2i(2,0)
		Gnome.GnomeTypes.GNIGHT:
			return Vector2i(3,1)
		Gnome.GnomeTypes.GNUN:
			return Vector2i(6,0)
		Gnome.GnomeTypes.GNAVE:
			return Vector2i(6,1)
		Gnome.GnomeTypes.GNOME_LONGER_WITH_US:
			return Vector2i(7,1)
		Gnome.GnomeTypes.MAGICIAGN:
			return Vector2i(1,1)
		Gnome.GnomeTypes.GNOT_LONG_FOR_THIS_WORLD:
			return Vector2i(3,0)
		Gnome.GnomeTypes.MUSICIAGN:
			return Vector2i(4,0)
		_:
			return Vector2i(4,1)

func gnome_round():
	var round_actions_taken = 0
	for gnome in get_children():
		if gnome is Gnome:
			#for ap in range(gnome.action_points):
			if gnome.action_points > 0:
				#print(Gnome.GnomeTypes.keys()[gnome.gnome_type])
				gnome.action_plan()
				gnome.action_points -= 1
				round_actions_taken += 1
	#print(round_actions_taken)
	return round_actions_taken

func gnome_end_round():
	for gnome in get_children():
		if gnome is Gnome:
			gnome.end_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	second_timer += delta
	if second_timer >= 1.0:
		second_timer -= 1.0
		if not gnome_round():
			second_timer += 1.0
			gnome_end_round()
		else:
			second_timer += 0.8

func tile_move(token_pos: Vector2i, dest_pos: Vector2i, move_layer: int = 1, floor_layer: int = 0) -> bool:
	if get_cell_source_id(move_layer,dest_pos) == -1 and get_cell_source_id(floor_layer,dest_pos) != -1:
		set_cell(move_layer, dest_pos,3,get_cell_atlas_coords(move_layer,token_pos), 0)
		erase_cell(move_layer, token_pos)
		return true
	else:
		return false

func get_gnomes_radius_diamond(get_position: Vector2i, range: int = 2, layer = 1):
	var found_tiles = []
	for x in range(-range, range + 1):
		for y in range(-range, range + 1):
			if abs(x) + abs(y) > range:
				continue
			var tile_position = get_position + Vector2i(x,y)
			#set_cell(0,tile_position,0,Vector2i(2,0))
			if get_cell_source_id(layer,tile_position) != -1:
				found_tiles.append(tile_position)
	print(found_tiles)
	return found_tiles
