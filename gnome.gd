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
var label_a_duration = Label.new()
var tile_map

var special_points = 1
var action_points = 1

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

func special():
	if special_points > 0:
		print("Gnostic!")
	else:
		action_default()

func talk():
	print("Gn'ello!")

func action_plan():
	match randi() % ActionTypes.size():
		0:
			wander()
		1:
			special()
		2:
			talk()

func action_default():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#label_a_duration.text = str(a_duration)
	#label_a_duration.position = Vector2(0, -20)
	print("gneady")
	add_child(label_a_duration)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#label_a_duration.text = str(global_position.x)
	match a_state:
		AnimationStates.WALKING:
			travel(delta)
		AnimationStates.JIGGLING:
			jiggle(delta)

func jiggle(delta):
	if(a_duration > 0 or sin(a_duration) == 0):
		$Sprite2D.global_position.x = original_global_position.x + (sin(a_duration_total - a_duration) * 3)
		#a_duration = a_duration - 1
		a_duration -= delta * 20
	else:
		a_state = AnimationStates.IDLE
		$Sprite2D.global_position.x = original_global_position.x
		print("done")

func travel(delta):
	var direction = target_global_position - global_position
	var distance_to_move = speed * delta
	var distance_to_target = direction.length()
	
	speed = (base_speed * 2 + (base_speed * distance_to_target/ max(distance_to_move,1))) / 3
	#print(speed)
	if distance_to_target <= distance_to_move:
		# Close enough to snap to the target.
		global_position = target_global_position
		#moving = false
		a_state = AnimationStates.IDLE
	else:
		# Move towards the target, clamping the movement to the distance to the target.
		global_position += direction.normalized() * distance_to_move

func move(move_pos):
	if not tile_map.is_tile_occupied(move_pos):
		print("before: ", tile_map_position)
		tile_map_position = tile_map.local_to_map(move_pos)
		print("after: ", tile_map_position)
		target_global_position = tile_map.map_to_local(tile_map_position)# + Vector2(tile_map.rendering_quadrant_size / 2, tile_map.rendering_quadrant_size / 2)
		#moving = true
		a_state = AnimationStates.WALKING

func move_map(move_pos):
	print(tile_map)
	print(owner)
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
