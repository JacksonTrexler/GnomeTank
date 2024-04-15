extends Gnome

func _ready():
	default_texture = preload("uid://ctowkdx25a87g")
	gnome_type = GnomeTypes.GNECROMANCER
	super._ready()
	special_points = 3
	special_points_max = 3
	special_points_recovery = 1

func talk():
	print("Gnehehe")
	
func try_special():
	if special_points > 0:
		if special():
			special_points -= 1
		else:
			action_default()
	#Check for nearby dead gnomes

func special() -> bool:
	var potential_graves = tile_map.get_surrounding_cells(tile_map_position)
	var siblings = get_parent().get_children()
	var found = false
	print("Dark Gnumenescent forces coallesce within me!")
	for grave in potential_graves:
		if Vector2i(tile_map.get_cell_atlas_coords(1, grave)) == Vector2i(7,1):
			tile_map.get_gnome(Vector2i(grave)).revive()
			found = true
			sprite_flash(Color.GREEN)
	return found

