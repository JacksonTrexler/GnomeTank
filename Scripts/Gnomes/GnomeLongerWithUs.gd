extends Gnome

#Default
var gnome_type_original = GnomeTypes.GNOBODY_IN_PARTICULAR
var revive_effect
#uid://cqk1pmiw706xb

func _ready():
	default_texture = preload("uid://cqk1pmiw706xb")
	super._ready()
	special_points = 1
	special_points_max = 1

func _init():
	frames = preload('uid://7tqtp7gqn7af') #res://Sprites/Effects/RetroImpactEffects/RetroImpactSpriteFrames.tres
	gnome_type = GnomeTypes.GNOME_LONGER_WITH_US

func wander():
	#Graves don't walk
	pass
	
func talk():
	print("...")

func special():
	haunt()
	
func haunt():
	#IMPLEMENT Display spooky effect, prevent neighbors from taking actions next turn
	play_animation_spooky()
	print("oOoOo")

func revive():
	gnome_type = gnome_type_original
	setup_animation("green_cloud")
	print("Resurrected, now change script and tile")
	#IMPLEMENT

#UTILITY FUNCTIONS

func play_animation_spooky():
	setup_animation("white_star")
