extends Gnome

var second_wind

func _ready():
	gnome_type = GnomeTypes.GNOT_LONG_FOR_THIS_WORLD
	super._ready()

func special():
	suicide()

func wander():
	if not second_wind:
		suicide()
	else:
		super()

func talk():
	print("What's the point?")
	suicide()

func suicide():
	if not second_wind:
		special_points -= 1
		print("Goodbye, cruel Gnomeworld™")
		second_wind = true
		death()
	else:
		print("lease on life")
		special_points -= 1
