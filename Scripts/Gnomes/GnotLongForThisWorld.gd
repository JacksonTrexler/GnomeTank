extends Gnome

func _ready():
	gnome_type = GnomeTypes.GNOT_LONG_FOR_THIS_WORLD
	super._ready()

func special():
	suicide()

func wander():
	suicide()

func talk():
	print("What's the point?")
	suicide()

func suicide():
	action_points -= 1
	print("Goodbye, cruel Gnomeworld™")
	death()
