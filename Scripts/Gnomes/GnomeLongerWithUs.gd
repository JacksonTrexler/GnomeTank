extends Gnome

#Default
var gnome_type_original = GnomeTypes.GNOBODY_IN_PARTICULAR
var retro_impact_sprite_frames = preload('uid://7tqtp7gqn7af') #res://Sprites/Effects/RetroImpactEffects/RetroImpactSpriteFrames.tres
var animation_effect
var revive_effect

func _init():
	gnome_type = GnomeTypes.GNOME_LONGER_WITH_US

func setup_animation(animation):
	if not animation_effect:
		animation_effect = AnimatedSprite2D.new()
		animation_effect.frames = retro_impact_sprite_frames
		animation_effect.animation = animation
		add_child(animation_effect)
		animation_effect.play()
		await animation_effect.animation_looped
		animation_effect.pause()

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
