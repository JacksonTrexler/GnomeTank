extends Gnome

var song = 0
var known_songs = [0]

# Called when the node enters the scene tree for the first time.
func _ready():
	gnome_type = GnomeTypes.MUSICIAGN
	default_texture = load('uid://cl1u8vwt0c42q')
	super()
	
	
func special():
	special_points -= 1
	perform(song)
	print("Singing")

func perform(selected_song):
	pass
