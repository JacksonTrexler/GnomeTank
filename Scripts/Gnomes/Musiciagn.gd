extends Gnome

var song = 0
var known_songs = [0]

# Called when the node enters the scene tree for the first time.
func _ready():
	gnome_type = GnomeTypes.MUSICIAGN
	default_texture = load('uid://cl1u8vwt0c42q')
	gnome_type = GnomeTypes.GNECROMANCER
	super()
	print("gbard")
	
func talk():
	print("Wanna hear a tune?")

func special():
	special_points -= 1
	perform(song)
	print("Singing")

func perform(selected_song):
	#get gnomes within 2 tiles
	match song:
		0:
			print("0000")
			tile_map.get_gnomes_radius_diamond(tile_map_position)
		_:
			pass
