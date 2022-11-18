extends Node2D


onready var buildmap = $BuildingMap
onready var cursormap = $CursorMap
onready var buildobjs = $BuildingObjects

var cursor_pos = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	update_cursor()

func build_at(pos):
	var build_pos = buildmap.world_to_map(pos)
	buildmap.set_cell(build_pos.x, build_pos.y, 0)
	
func put_cursor(pos):
	cursor_pos = cursormap.world_to_map(pos)

func update_cursor():
	for tile in cursormap.get_used_cells():
		cursormap.set_cell(tile.x, tile.y, -1)
	if cursor_pos != null:
		cursormap.set_cell(cursor_pos.x, cursor_pos.y, 0)
		cursor_pos = null
	
