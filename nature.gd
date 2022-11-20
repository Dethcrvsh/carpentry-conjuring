extends Node2D

onready var path_finder = get_parent().get_node("PathFinder")
onready var base = get_parent().get_node("Base")
onready var collision_map = get_parent().get_node("ObjectMaster").get_node("CollisionMap")

const TREE = preload("res://Gran.tscn")
const HOUSE_RADIUS = 13
const ROAD_RADIUS = 3
const TREE_NUM = 1000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_trees(TREE_NUM)

func spawn_trees(num):
	var spawn_points = get_random_spawn_points(num)
	
	for point in spawn_points:
		var tree = TREE.instance()
		tree.position = get_world_coords(point)
		self.add_child(tree)
	

func get_random_spawn_points(num):
	randomize()
	var spawn_points = []
	var min_bound = path_finder.min_boundary
	var max_bound = path_finder.max_boundary
	print(max_bound.x - min_bound.x)
	
	while spawn_points.size () < num:
		var x = (randi() % int(max_bound.x - min_bound.x)) + min_bound.x
		var y = (randi() % int(max_bound.y - min_bound.y)) + min_bound.y
		var point = Vector2(x, y)
		
		# Check the distance to the house
		if point.distance_to(base.get_position()) < HOUSE_RADIUS:
			continue
		
		if abs(x) < ROAD_RADIUS or abs(y) < ROAD_RADIUS:
			continue
				
		if point in spawn_points:
			continue
			
		spawn_points.append(point)
	
	return spawn_points

func get_world_coords(point: Vector2) -> Vector2:
	return collision_map.map_to_world(point) + collision_map.get_cell_size()/2
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
