extends Node2D


onready var collmap = $CollisionMap
onready var cursormap = $CursorMap
onready var objs = $Objects

const Stol = preload("res://Stol.tscn")
const Gran = preload("res://Gran.tscn")
const wood_drop = preload("res://wood_drop.tscn")

var cursor_pos = null

const buildings = {"BlOCKSHELF":Stol, "STOL":Stol, "ARMEDCHAIR":Stol}
const fauna = {"GRAN":Gran,}
const fauna_drop = {"GRAN":wood_drop}

# Given in mouse pos
const GRAN_POS = [Vector2(-9, 0)]

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
	print(cursor_pos)

func update_cursor():
	for tile in cursormap.get_used_cells():
		cursormap.set_cell(tile.x, tile.y, -1)
	if cursor_pos != null:
		cursormap.set_cell(cursor_pos.x, cursor_pos.y, 1)
		cursor_pos = null
	
func spawn_trees():
	for pos in GRAN_POS:
		var gran_instance = fauna["GRAN"].instance()
		var new_pos = cursormap.map_to_world(pos)
		place_object(new_pos, gran_instance)

func remove_collision(pos):
	var map_pos = collmap.world_to_map(pos)
	collmap.set_cell(map_pos.x, map_pos.y, -1)

func spawn_wood_drop(pos, tree_type):
	var wood_drop_instance = fauna_drop["GRAN"].instance()
	get_parent().add_child(wood_drop_instance)
	wood_drop_instance.position = pos