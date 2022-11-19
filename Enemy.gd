extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
onready var base = get_parent().get_parent().get_node("Base")
onready var path_finder = get_parent().get_parent().get_node("PathFinder")

# If the player gets inside this radius of the enemy, he go rage mode
const ANGER_RADIUS = 50
const ATTACK_RADIUS = 20

const DAMAGE = 5
const ATTACK_SPEED = 1

const ANGER_TIME = 5

const MOVEMENT_SPEED = 25
const ANGER_MOVEMENT_SPEED = 70

# Different states of behaviour
const ANGRY = 0
const ATTACK_BASE = 1

# The current state of the enemy. Might want a combination of
# behaviours in the future
var states = []

var path = []

# Counters for keeping track of time limits related to behaviours
var angry_counter = 0
var last_attack = ATTACK_SPEED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	handle_states()
	
	if ANGRY in states:
		do_anger(delta)
	elif ATTACK_BASE in states:
		do_base_attack()
	
	if get_player_distance() < ATTACK_RADIUS and last_attack >= ATTACK_SPEED:
		last_attack = 0
		player.take_damage(5)
	
	last_attack += delta

func handle_states():
	"""Handle the different states of the enemies behaviour"""
	# If enemy has no state, attack the base
	if not states:
		states.append(ATTACK_BASE)
		path = path_finder.calc_path(self.get_position(), base.get_position())
			
	# Stop attacking the base and become angry
	if not ANGRY in states and get_player_distance() < ANGER_RADIUS:
		states.append(ANGRY)
		states.erase(ATTACK_BASE)
		
		angry_counter = 0

	if angry_counter >= ANGER_TIME:
		states.erase(ANGRY)

func do_anger(delta):
	move_towards(player.get_position(), ANGER_MOVEMENT_SPEED)
	angry_counter += delta

func do_base_attack():
	follow_path()

func get_player_distance() -> float:
	return self.get_position().distance_to(player.get_position())

func follow_path():
	if path:
		var next_point = path[0]
		if self.get_position().distance_to(next_point) <= 1:
			path.pop_front()
		else:
			move_towards(next_point, MOVEMENT_SPEED)

func move_towards(point: Vector2, speed: int):
	var enemy_pos = self.get_position()
	
	var vel = Vector2(
		point.x - enemy_pos.x, 
		point.y - enemy_pos.y
	).normalized()
	
	move_and_slide(vel * speed)
	flip_sprite(vel)

func flip_sprite(vel: Vector2):
	# TODO: Stop the spasm
	var dir = vel.x
	
	if dir < 0:
		get_node("Sprite").set_flip_h(true)
	elif dir > 0:
		get_node("Sprite").set_flip_h(false)

func hit_by_proj():
	print("Oof")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
