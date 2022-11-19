extends Area2D
onready var collision = $collisionarea

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func collision(thing):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for thing in get_overlapping_areas():
		collision(thing)
	for thing in get_overlapping_bodies():
		collision(thing)
