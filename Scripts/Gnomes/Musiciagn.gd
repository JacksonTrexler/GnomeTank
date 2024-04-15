extends Gnome

var song = 0
var known_songs = [0]

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
func special():
	special_points -= 1
	perform(song)
	print("Singing")

func perform(selected_song):
	pass
