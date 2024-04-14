extends Gnome

var second_wind

func _ready():
	print("typeset")
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
	if not second_wind:
		print("What's the point?")
	else:
		print("One day at a time!")

func suicide():
	if not second_wind:
		special_points -= 1
		print("Goodbye, cruel Gnomeworld™")
		second_wind = true
		death()
	else:
		action_points += 2
		special_points -= 1
