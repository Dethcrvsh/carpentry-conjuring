extends Node2D


onready var collmap = $CollisionMap
onready var cursormap = $CursorMap
onready var objs = $Objects
onready var path_finder = get_parent().get_node("PathFinder")

const Stol = preload("res://Stol.tscn")
const books = preload("res://Bookshelf.tscn")
const armc = preload("res://Armchair.tscn")
const Gran = preload("res://Gran.tscn")
const wood_drop = preload("res://wood_drop.tscn")

var cursor_pos = null

const buildings = {"BlOCKSHELF":books, "STOL":Stol, "ARMEDCHAIR":armc}
const fauna = {"GRAN":Gran}
const fauna_drop = {"GRAN":wood_drop}

# Given in mouse pos
const GRAN_POS = [Vector2(-9, 0), Vector2(-13, 5), Vector2(-20, 10), Vector2(9, 3),
				  Vector2(0, 20), Vector2(9, 10), Vector2(-19, 10), Vector2(5, -5), 
				  Vector2(0, -7), Vector2(-8, -8), Vector2(-6, 6), Vector2(15, 9), 
				  Vector2(-19, 3), Vector2(0, 6), Vector2(12, -3), Vector2(19, 1), 
				  Vector2(19, -7), Vector2(13, 13), Vector2(13, 37), Vector2(4, -9), 
				  Vector2(-7, -4), Vector2(-11, 9)]


# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn in the trees the first time the scene is loaded
	spawn_trees()

func _process(delta):
	update_cursor()

func build_at(pos, type):
	var build_instance = buildings[type].instance()
	place_object(pos, build_instance)

func place_object(pos, instance):
	# add collision
	var col_build_pos = collmap.world_to_map(pos)
	collmap.set_cell(col_build_pos.x, col_build_pos.y, 0)
	# add build object
	var obj_build_pos = collmap.map_to_world(col_build_pos)
	objs.add_child(instance)
	instance.position = obj_build_pos + collmap.get_cell_size()/2
	
func put_cursor(pos):
	cursor_pos = cursormap.world_to_map(pos)

func add_collision(pos):
	collmap.set_cell(pos.x, pos.y, 0)

func update_cursor():
	for tile in cursormap.get_used_cells():
		cursormap.set_cell(tile.x, tile.y, -1)

	if cursor_pos != null:
		cursormap.set_cell(cursor_pos.x, cursor_pos.y, 0)
		cursor_pos = null
	
func spawn_trees():
	for pos in GRAN_POS:
		var gran_instance = fauna["GRAN"].instance()
		var new_pos = cursormap.map_to_world(pos)
		place_object(new_pos, gran_instance)

func remove_collision(pos):
	var map_pos = collmap.world_to_map(pos)
	collmap.set_cell(map_pos.x, map_pos.y, -1)
	path_finder.remove_point(pos)

func spawn_wood_drop(pos, tree_type):
	var wood_drop_instance = fauna_drop["GRAN"].instance()
	get_parent().add_child(wood_drop_instance)
	wood_drop_instance.position = pos
