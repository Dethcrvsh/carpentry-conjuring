extends KinematicBody2D

onready var player = get_parent().get_parent().get_node("Player")
onready var base = get_parent().get_parent().get_node("Base")
onready var path_finder = get_parent().get_parent().get_node("PathFinder")
onready var objects = get_parent().get_parent().get_node("ObjectMaster").get_node("Objects")
onready var attack_points = get_parent().get_parent().get_node("BaseTargets")

# If the player gets inside this radius of the enemy, he go rage mode
const ANGER_RADIUS = 30
const ATTACK_RADIUS = 20

const DAMAGE = 5
const ATTACK_SPEED = 1
const HOUSE_DMG = DAMAGE

const ANGER_TIME = 3

const MOVEMENT_SPEED = 25
const ANGER_MOVEMENT_SPEED = 70
const STUCK_COOLDOWN = 50

var stuck_cooldown = 0
var max_hp = 20
var current_hp = max_hp

# Different states of behaviour
const ANGRY = 0
const ATTACK_BASE = 1
const STUCK = 2
const ATTACK_FURNITURE = 3

const ATTACK_FURNITURE_CHANCE = 5
const INTEREST_TIME = 1

# The current state of the enemy. Might want a combination of
# behaviours in the future
var states = []

var path = []

# Counters for keeping track of time limits related to behaviours
var angry_counter = 0
var interest_counter = 0
var last_attack = ATTACK_SPEED
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _process(delta):
	pass

func _physics_process(delta):
	handle_states()
	if ATTACK_BASE in states or ATTACK_FURNITURE in states:
		# Attack furniture
		if interest_counter > INTEREST_TIME:
			if (randi() % 100) < ATTACK_FURNITURE_CHANCE:
				if ATTACK_BASE in states:
					states = []
					states.append(ATTACK_FURNITURE)
				elif ATTACK_FURNITURE in states:
					states = []
			interest_counter = 0
	
	interest_counter += delta
	
	if STUCK in states:
		do_stuck()
	elif ANGRY in states:
		do_anger(delta)
	elif ATTACK_BASE in states:
		do_base_attack(delta)
	elif ATTACK_FURNITURE in states:
		do_furniture_attack()
	
	if get_player_distance() < ATTACK_RADIUS and last_attack >= ATTACK_SPEED:
		last_attack = 0
		player.take_damage(5)
	
	last_attack += delta
	check_if_dead()

func handle_states():
	"""Handle the different states of the enemies behaviour"""
	# If enemy has no state, attack the base
	if not states:
		interest_counter = 0
		states.append(ATTACK_BASE)
		path = calc_path(base.get_position())
		
		if not path:
			print("tried going to " + str(target.get_position()))
			
	# Stop attacking the base and become angry
	if not ANGRY in states and get_player_distance() < ANGER_RADIUS:
		states.append(ANGRY)
		states.erase(ATTACK_BASE)
		
		angry_counter = 0

	if angry_counter >= ANGER_TIME:
		states.erase(ANGRY)

func calc_path(point: Vector2):
	return path_finder.calc_path(self.get_position(), point)

func do_furniture_attack():
	var furniture = objects.get_children()
	
	# The furniture has died
	if target and not is_instance_valid(target):
		target = null
		states = []
		path = []
		return
	
	if not target:
		if furniture:
			furniture.shuffle()
			target = furniture[0]
			path = []
			print("target: " + str(target))
		else:
			states = []
			states.append(ATTACK_BASE)
	elif not path:
		var furn = target.get_position()
		var dir = [-16, 16]
		dir.shuffle()
		var dir_x = 0
		var dir_y = 0
		
		if randi()%2 == 0:
			dir_x = dir[0]
		else:
			dir_y = dir[0]

		path = calc_path(Vector2(furn.x + dir_x, furn.y + dir_y))
	else:
		follow_path()
		

func do_anger(delta):
	move_towards(player.get_position(), ANGER_MOVEMENT_SPEED)
	angry_counter += delta

func do_base_attack(delta):
	follow_path()

func do_stuck():
	stuck_cooldown -= 1
	if stuck_cooldown == 0:
		become_unstuck()

func get_player_distance() -> float:
	return self.get_position().distance_to(player.get_position())

func follow_path():
	if path:
		var next_point = path[0]
		if self.get_position().distance_to(next_point) <= 3:
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

func hit_by_proj(dmg):
	current_hp -= dmg
	
func hit_by_axe():
	current_hp -= 5
	
func check_if_dead():
	if current_hp <= 0:
		queue_free()

func set_hp(num):
	current_hp = num
	max_hp = num

func is_enemy():
	pass

func allow_hit_base():
	if ATTACK_BASE in states and last_attack >= ATTACK_SPEED:
		last_attack = 0
		base.take_dmg(HOUSE_DMG)

func become_stuck():
	stuck_cooldown = STUCK_COOLDOWN
	states = [STUCK]

func become_unstuck():
	states = []

func allow_hit_built(thing):
	if thing == target:
		thing.take_dmg(DAMAGE)

func update_path():
	if path:
		path = calc_path(path[len(path)-1])
