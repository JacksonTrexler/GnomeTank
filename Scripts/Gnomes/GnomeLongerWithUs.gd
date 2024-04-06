extends Gnome

#Default
var gnome_type_original = GnomeTypes.GNOBODY_IN_PARTICULAR

func _init():
	gnome_type = GnomeTypes.GNOME_LONGER_WITH_US
	
func try_special():
	if(special_points > 0):
		special_points -= 1
		special()

func wander():
	pass
	
func talk():
	print("...")

func special():
	haunt()
	
func haunt():
	#IMPLEMENT Display spooky effect, prevent neighbors from taking actions next turn
	print("oOoOo")

func revive():
	gnome_type = gnome_type_original
