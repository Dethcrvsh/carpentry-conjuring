extends Node2D


onready var collmap = $CollisionMap
onready var cursormap = $CursorMap
onready var objs = $Objects

const Stol = preload("res://Stol.tscn")
const Gran = preload("res://Gran.tscn")

var cursor_pos = null
const buildings = {"BlOCKSHELF":Stol, "STOL":Stol, "ARMEDCHAIR":Stol}
const fauna = {"GRAN":Gran,}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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

func update_cursor():
	for tile in cursormap.get_used_cells():
		cursormap.set_cell(tile.x, tile.y, -1)
	if cursor_pos != null:
		cursormap.set_cell(cursor_pos.x, cursor_pos.y, 1)
		cursor_pos = null
	
