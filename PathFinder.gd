extends Node

const CELL_EMPTY = -1

onready var object_master = get_parent().get_node("ObjectMaster")
onready var collision_map = object_master.get_node("CollisionMap")

var astar = AStar2D.new()

var min_boundary = null
var max_boundary = null


# Called when the node enters the scene tree for the first time.
func _ready():
	set_boundaries()
	init_graph()

func calc_path(from: Vector2, to: Vector2) -> Array:
	var start_point = collision_map.world_to_map(from)
	var end_point = collision_map.world_to_map(to)

	var start_index = get_point_index(start_point)
	var end_index = get_point_index(end_point)
	
	var path = astar.get_point_path(start_index, end_index)
	var path_world = []
	
	for point in path:
		path_world.append(collision_map.map_to_world(point) + collision_map.get_cell_size()/2)
	
	return path_world

func init_graph():
	for y in range(min_boundary.y, max_boundary.y):
		for x in range(min_boundary.x, max_boundary.x):
			# Only check the empty cells
			if collision_map.get_cell(x, y) == CELL_EMPTY:
				var point = Vector2(x, y)
				# Calculate the index and add the point
				var p_index = get_point_index(point)
				
				astar.add_point(p_index, point)
				
				var neighbours = []
				
				if not point.x == min_boundary.x:
					neighbours.append(Vector2(-1, 0))
				if not point.y == min_boundary.y:
					neighbours.append(Vector2(0, -1))
				if not point.x == min_boundary.x and not point.y == min_boundary.y:
					neighbours.append(Vector2(-1, -1))
				
				# Only check neighbours with lower coordinates to not do double work
				for neighbour in neighbours:
					var neigh_point = point + neighbour
					
					# If the neighbour is traversable, add a path
					if collision_map.get_cell(neigh_point.x, neigh_point.y) == CELL_EMPTY:
						var neigh_index = get_point_index(neigh_point)
						astar.connect_points(p_index, neigh_index, true)
	
func set_boundaries():
	var min_coord = Vector2(INF, INF)
	var max_coord = Vector2(-INF, -INF)
	
	for point in collision_map.get_used_cells():
		if point.x < min_coord.x:
			min_coord.x = point.x
		if point.y < min_coord.y:
			min_coord.y = point.y
		if point.x > max_coord.x:
			max_coord.x = point.x
		if point.y > max_coord.y:
			max_coord.y = point.y
	
	min_boundary = min_coord
	max_boundary = max_coord

func get_point_index(point: Vector2) -> int:
	point = point - min_boundary
	return point.y * (max_boundary.x - min_boundary.x) + point.x

func remove_point(point: Vector2):
	point = collision_map.world_to_map(point)
	var index = get_point_index(point)
	
	for y in range(-1, 2):
		for x in range(-1, 2):
			if x == 0 and y == 0:
				continue
			
			var neigh_point = Vector2(x, y) + point
			var neigh_index = get_point_index(neigh_point)
			
			if not astar.has_point(neigh_index):
				continue
			
			astar.connect_points(index, neigh_index, true)

func add_point(point: Vector2):
	point = collision_map.world_to_map(point)
	var index = get_point_index(point)
	
	for y in range(-1, 2):
		for x in range(-1, 2):
			if x == 0 and y == 0:
				continue
			
			var neigh_point = Vector2(x, y) + point
			var neigh_index = get_point_index(neigh_point)
			
			if not astar.has_point(neigh_index):
				continue
			
			astar.disconnect_points(index, neigh_index, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
