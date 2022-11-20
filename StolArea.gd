extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for thing in get_overlapping_areas():
		if thing.has_method("is_enemy"):
			thing.allow_hit_built()
			
	for thing in get_overlapping_bodies():
		if thing.has_method("is_enemy"):
			thing.allow_hit_built()
