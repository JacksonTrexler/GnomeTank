extends Gnome



func _ready():
	super._ready()
	special_points = 1
	special_points_max = 1

func setup_texture():
	texture = load("uid://ctowkdx25a87g")
	sprite.texture = texture
	#sprite.apply_scale(Vector2(0.05,0.05))
	var scaler = 32 / texture.get_size().y
	sprite.apply_scale(Vector2(scaler,scaler))

func talk():
	print("Gnehehe")
	
func try_special():
	if special_points > 0:
		if special():
			special_points -= 1
		else:
			action_default()
	#Check for nearby dead gnomes

func wander():
	try_special()
	
func special() -> bool:
	var potential_graves = tile_map.get_surrounding_cells(tile_map_position)
	var siblings = get_parent().get_children()
	var found = false
	print("Dark Gnumenescent forces coallesce within me!")
	for grave in potential_graves:
		if Vector2i(tile_map.get_cell_atlas_coords(1, grave)) == Vector2i(7,1):
			tile_map.get_gnome(Vector2i(grave)).revive()
			found = true
			#flash_sprite()
			print("bim")
			tween = get_tree().create_tween()
			tween.tween_property(sprite, "modulate", Color.GREEN, 0.2).set_trans(Tween.TRANS_SINE)
			tween.tween_property(sprite, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE)
	return found
