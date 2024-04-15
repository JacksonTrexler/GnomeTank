#Class definition
class_name Gnome

# Inheritance
extends Node2D

var tile_map_position = Vector2()
var selected = false
var base_speed = 25
var speed = 25 # Units per second
var moving = false
var jiggling = false
var a_state = "idle"
var a_duration = 0
var a_duration_total = 1
var target_global_position = Vector2()
var original_global_position = Vector2()
var tile_map

var special_points = 1
var special_points_max = 1
var special_points_recovery = 5
var special_points_recovery_threshold = 100
var special_points_recovery_total = 0
var action_points = 1
var action_points_recovery = 1
var action_points_max = 1

var gnome_type
var original_script
var gnome_original

var sprite : Sprite2D
var texture : Texture2D
var tween : Tween

var frames = preload('uid://7tqtp7gqn7af')
var default_texture = preload("uid://hnop25namqjn")
var gnome_scene = preload("uid://bwiq87l7psgif")

enum AnimationStates {
	IDLE,
	WALKING,
	JIGGLING
}

enum ActionTypes {
	WANDER,
	SPECIAL,
	TALK
}

enum GnomeTypes {
	GNOBODY_IN_PARTICULAR,
	GNECROMANCER,
	GNIGHT,
	GNUN,
	GNAVE,
	GNOME_LONGER_WITH_US,
	MAGICIAGN,
	GNOT_LONG_FOR_THIS_WORLD
}

func special():
	print("Gnostalgic!")

func try_special():
	if special_points > 0:
		special_points -= 1
		special()
	else:
		action_default()

func talk():
	print("Gn'ello!")

func action_plan():
	if action_points > 0:
		match randi() % ActionTypes.size():
			0:
				wander()
			1:
				try_special()
			2:
				talk()
	#end_turn()

func end_turn():
	recover_special()
	recover_action()
	
			
func recover_special():
	if special_points < special_points_max:
		special_points_recovery_total += special_points_recovery
		if special_points_recovery_total >= special_points_recovery_threshold:
			special_points += 1 #WIS?
			special_points_recovery_total -= special_points_recovery_threshold

func recover_action():
	if action_points < action_points_max:
		action_points += action_points_recovery
		if action_points > action_points_max:
			action_points = action_points_max

func action_default():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	if not tile_map:
		tile_map = get_parent()
	setup_sprite()
	setup_texture(default_texture)
	setup_tween()
	print("gnosty")
	pass

func death():
	#var tombstone = gnome_scene.instantiate()
	#add_sibling(tombstone)
	#tombstone.add_script("res://Scripts/Gnomes/GnomeLongerWithUs.gd")
	#tombstone.script = load("res://Scripts/Gnomes/GnomeLongerWithUs.gd")
	#tombstone.gnome_original = self
	tile_map.set_cell(1,tile_map_position,3,tile_map.determine_gnome_tile(GnomeTypes.GNOME_LONGER_WITH_US))
	var tombstone = tile_map.spawn_gnome(tile_map_position)
	tombstone.gnome_original = self
	tile_map.remove_child(self)
	set_process(false)
	

func revive():
	pass

func setup_sprite():
	if not sprite:
		sprite = Sprite2D.new()
		add_child(sprite)

func setup_texture(setup_texture = load("uid://hnop25namqjn")):
	texture = setup_texture
	sprite.texture = texture
	
	#Reserved for small, stout, and tall sprites as gneeded
	#sprite.apply_scale(Vector2(0.05,0.05))
	#sprite.apply_scale(Vector2(32,32) / texture.get_size())
	var scaler = 32 / texture.get_size().y
	sprite.apply_scale(Vector2(scaler,scaler))

func setup_animation(animation):
	var animation_effect = AnimatedSprite2D.new()
	animation_effect.frames = frames
	animation_effect.animation = animation
	animation_effect.z_index = 2
	add_child(animation_effect)
	animation_effect.play()
	await animation_effect.animation_looped
	animation_effect.pause()
	return true
	
func setup_tween():
	tween = get_tree().create_tween()
	#add_child(tween)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match a_state:
		AnimationStates.WALKING:
			travel(delta)
		AnimationStates.JIGGLING:
			jiggle(delta)

func jiggle(delta):
	if(a_duration > 0 or sin(a_duration) == 0):
		sprite.global_position.x = original_global_position.x + (sin(a_duration_total - a_duration) * 3)
		a_duration -= delta * 20
	else:
		a_state = AnimationStates.IDLE
		sprite.global_position.x = original_global_position.x

func travel(delta):
	var direction = target_global_position - global_position
	var distance_to_move = speed * delta
	var distance_to_target = direction.length()
	
	speed = (base_speed * 2 + (base_speed * distance_to_target/ max(distance_to_move,1))) / 3
	if distance_to_target <= distance_to_move:
		# Close enough to snap to the target.
		global_position = target_global_position
		a_state = AnimationStates.IDLE
	else:
		# Move towards the target, clamping the movement to the distance to the target.
		global_position += direction.normalized() * distance_to_move

func move(move_pos):
	if not tile_map.is_tile_occupied(move_pos):
		tile_map_position = tile_map.local_to_map(move_pos)
		target_global_position = tile_map.map_to_local(tile_map_position)# + Vector2(tile_map.rendering_quadrant_size / 2, tile_map.rendering_quadrant_size / 2)
		a_state = AnimationStates.WALKING

func move_map(move_pos):
	if tile_map.tile_move(tile_map_position, move_pos):
		tile_map_position = move_pos
		target_global_position = tile_map.map_to_local(tile_map_position)# + Vector2(tile_map.rendering_quadrant_size / 2, tile_map.rendering_quadrant_size / 2)
		a_state = AnimationStates.WALKING
	else:
		original_global_position = global_position
		a_duration = 4 * PI
		a_duration_total = 4 * PI
		a_state = AnimationStates.JIGGLING
		print(a_state)

func _input(event):
	if event.is_action_pressed("ui_accept"): # Checking if spacebar is pressed
		action_plan()

func update_tile_map_position():
	#var tile_map = get_node("%GnomeBoard") # Adjust the path to your TileMap node
	tile_map_position = tile_map.local_to_map(global_position)
	global_position = tile_map.map_to_local(tile_map_position)
	print(tile_map_position)
	
func wander():
	var directions = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
	var random_index = randi() % directions.size()
	var desired_move = Vector2(tile_map_position.x + directions[random_index].x,tile_map_position.y + directions[random_index].y)
	move_map(desired_move)

#Animation
func sprite_flash(color : Color):
	# Set the initial modulate color to normal
	tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", color, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_SINE)

func sprite_hide():
	tween = get_tree().create_tween()
	tween.tween_property(sprite,"modulate", Color.TRANSPARENT, 1).set_ease(Tween.EASE_IN)

func sprite_fade_in():
	tween = get_tree().create_tween()
	sprite.modulate.a = 0
	#tween.tween_property(sprite,"modulate", Color.TRANSPARENT, 0.01).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite,"modulate", Color.WHITE, 2).set_ease(Tween.EASE_IN)
