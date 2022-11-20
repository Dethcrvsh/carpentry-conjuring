extends Node2D


class EnemySpawn:
	var spread: float
	var initial_rate: int
	var ramp: float
	
	func _init(spread_in: float, initial_rate_in: int, ramp_in: float):
		spread = spread_in
		initial_rate = initial_rate_in
		ramp = ramp_in
	
	func get_spawn_num(wave_num: int) -> int:
		var spawn = int(initial_rate * pow(ramp, wave_num))
		var min_spawn = int(spawn * (1 - spread))
		var max_spawn = int(spawn * (1 + spread))
		return randi() % (max_spawn - min_spawn) + min_spawn


onready var SPAWN_POINTS = [
	get_parent().get_parent().get_node("SpawnPoints").get_node("North"),
	get_parent().get_parent().get_node("SpawnPoints").get_node("East"),
	get_parent().get_parent().get_node("SpawnPoints").get_node("South"),
	get_parent().get_parent().get_node("SpawnPoints").get_node("West"),
]
onready var enemies_node = get_parent().get_parent().get_node("enemies")

var wave_num = 0

# The number of directions with the corresponding wave
var num_of_dir = {[0, 1]: 1, [1, 2]: 2, [2, 3]: 3, [3, INF]: 4}

# Enums for directions
const NORTH = 0
const EAST = 1
const SOUTH = 2
const WEST = 3

# Enums for enemies
const TROLL = 0
const TROLL2 = 1

const SPAWN_RATE = 2

var enemies = {
	TROLL: preload("res://Basic_enemy.tscn"),
	TROLL2: preload("res://Basic_enemy2.tscn")
}
var enemy_spawn = {
	TROLL: EnemySpawn.new(0.2, 3, 1.3),
	TROLL2: EnemySpawn.new(0.2, 3, 1.3)
}

var spawn_timer = 0
var spawns = []
var spawn_directions = []


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _process(delta):
	if spawns:
		if spawn_timer > SPAWN_RATE:
			spawn_next_enemy()
			spawn_timer = 0
		else:
			spawn_timer += delta

func spawn_next_enemy():
	var spawn = spawns.pop_front()

	spawn_directions.shuffle()
	var spawn_dir = spawn_directions[0]
	var spawn_position = SPAWN_POINTS[spawn_dir].get_position()
	
	var enemy = spawn.instance()
	enemy.position = spawn_position
	enemies_node.add_child(enemy)
	print("spawn " + str(enemy) + " pos: " + str(enemy.position))

func do_next_wave():
	spawn_directions = get_spawn_directions()
	spawns = []
	
	for enemy in enemies.keys():
		var num_of_spawns = enemy_spawn[enemy].get_spawn_num(wave_num)
		for i in range(num_of_spawns):
			spawns.append(enemies[enemy])
	
	spawns.shuffle()

func get_spawn_directions():
	var directions = [NORTH, EAST, SOUTH, WEST]
	directions.shuffle()
	var dir_num = get_num_of_dir()
	
	# Pop a random direction
	for i in range(4 - dir_num):
		directions.pop_front()
	
	return directions
	
func get_num_of_dir():
	for interval in num_of_dir.keys():
		if interval[0] <= wave_num and wave_num < interval[1]:
			return num_of_dir[interval]

func is_done_spawning():
	return spawns.size() == 0
