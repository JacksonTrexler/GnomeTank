extends Gnome

#Default
var gnome_type_original = GnomeTypes.GNOBODY_IN_PARTICULAR
var revive_effect
#uid://cqk1pmiw706xb

func _ready():
	setup_animation("white_cloud")
	gnome_type = GnomeTypes.GNOME_LONGER_WITH_US
	#if not gnome_original:
	#	gnome_original = gnome_scene.instantiate()
	#	add_sibling(gnome_original)
	#	gnome_original.hide()
	#	gnome_original.set_process(false)
	default_texture = preload("uid://cqk1pmiw706xb")
	super._ready()
	special_points = 1
	special_points_max = 1
	sprite_fade_in()

func _init():
	#frames = preload('uid://7tqtp7gqn7af') #res://Sprites/Effects/RetroImpactEffects/RetroImpactSpriteFrames.tres
	gnome_type = GnomeTypes.GNOME_LONGER_WITH_US

func wander():
	#Graves don't walk
	pass
	
func talk():
	#print("...")
	pass

func special():
	special_points -= 1
	#print(special_points)
	haunt()
	
func haunt():
	#IMPLEMENT Display spooky effect, prevent neighbors from taking actions next turn
	play_animation_spooky()
	#print("oOoOo")

func revive():
	#gnome_type = gnome_type_original
	#print("revive ", gnome_original)
	if gnome_original:
		#print("Resurrected, now change script and tile")
		gnome_original.show()
		gnome_original.set_process(true)
		add_sibling(gnome_original)
		#print(gnome_original.gnome_type)
		tile_map.set_cell(1,tile_map_position,3,tile_map.determine_gnome_tile(gnome_original.gnome_type))
		death()
	else:
		#Spawn skeletogn? Grave goodies? Otherwise just destroy it
		tile_map.set_cell(1,tile_map_position,3,Vector2i(-1,-1))
		death()
	#add_sibling(gnome_original)

func death():
	action_points = 0
	action_points_max = 0
	sprite_hide()
	await setup_animation("green_cloud")
	#print("Free")
	queue_free()

#UTILITY FUNCTIONS

func play_animation_spooky():
	setup_animation("white_star")
