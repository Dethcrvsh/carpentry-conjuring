extends Node2D


onready var collmap = $CollisionMap
onready var cursormap = $CursorMap
onready var objs = $Objects
onready var path_finder = get_parent().get_node("PathFinder")
onready var enemies = get_parent().get_node("enemies")

const Stol = preload("res://Stol.tscn")
const books = preload("res://Bookshelf.tscn")
const armc = preload("res://Armchair.tscn")
const wood_drop = preload("res://wood_drop.tscn")

var cursor_pos = null

const buildings = {"BlOCKSHELF":books, "STOL":Stol, "ARMEDCHAIR":armc}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	update_cursor()

func build_at(pos, type):
	var build_instance = buildings[type].instance()
	place_object(pos, build_instance)

func place_object(pos, instance):
	# add collision
	var col_build_pos = collmap.world_to_map(pos)
	add_collision(pos)
	# add build object
	var obj_build_pos = collmap.map_to_world(col_build_pos)
	objs.add_child(instance)
	instance.position = obj_build_pos + collmap.get_cell_size()/2
	
func put_cursor(pos):
	cursor_pos = cursormap.world_to_map(pos)

func add_collision(pos):
	var col_build_pos = collmap.world_to_map(pos)
	collmap.set_cell(col_build_pos.x, col_build_pos.y, 0)
	path_finder.add_point(pos)
	update_enemies()

func update_cursor():
	for tile in cursormap.get_used_cells():
		cursormap.set_cell(tile.x, tile.y, -1)

	if cursor_pos != null:
		cursormap.set_cell(cursor_pos.x, cursor_pos.y, 0)
		cursor_pos = null

func remove_collision(pos):
	var map_pos = collmap.world_to_map(pos)
	collmap.set_cell(map_pos.x, map_pos.y, -1)
	path_finder.remove_point(pos)
	update_enemies()

func update_enemies():
	for enemy in enemies.get_children():
		enemy.update_path()
