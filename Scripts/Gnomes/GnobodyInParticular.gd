extends Gnome

func _init():
	gnome_type = GnomeTypes.GNOBODY_IN_PARTICULAR
	action_points_max = 5

func talk():
	print("I'm gnormal")

func special():
	print("I'm gnew")
